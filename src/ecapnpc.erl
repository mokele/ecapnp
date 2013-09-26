%%  
%%  Copyright 2013, Andreas Stenius <kaos@astekk.se>
%%  
%%   Licensed under the Apache License, Version 2.0 (the "License");
%%   you may not use this file except in compliance with the License.
%%   You may obtain a copy of the License at
%%  
%%     http://www.apache.org/licenses/LICENSE-2.0
%%  
%%   Unless required by applicable law or agreed to in writing, software
%%   distributed under the License is distributed on an "AS IS" BASIS,
%%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%   See the License for the specific language governing permissions and
%%   limitations under the License.
%%  

-module(ecapnpc).
-author("Andreas Stenius <kaos@astekk.se>").

-export([compile_file/1,
         compile_data/1,
         compile_message/1]).

-include_lib("ecapnp/include/schema.capnp.hrl").


%% ===================================================================
%% API functions
%% ===================================================================

compile_file(FileName) ->
    {ok, Data} = file:read_file(FileName),
    compile_data(Data).

compile_data(Data)
  when is_binary(Data) ->
    {ok, Message} = ecapnp_message:read(Data),
    compile_message(Message).

compile_message(Message)
  when is_list(Message), is_binary(hd(Message)) ->
    {ok, Root} = schema(root, 'CodeGeneratorRequest', Message),
    Compiled = compile_root(Root),
    export(Compiled).

%% ===================================================================
%% internal functions
%% ===================================================================

export([Schema|Ss]) ->
    case export_schema(Schema) of
        ok -> export(Ss);
        Err -> Err
    end;
export([]) -> ok.

export_schema(#schema{ node=#node{ source=Src } }=Schema) ->
    FileName = get_output_filename(Src),
    {ok, File} = create_output_file(FileName),
    try 
        Out = fun ([Fmt|Args]) ->
                      ok = io:format(File, Fmt, Args) 
              end,
        [Write(Out, Schema) 
         || Write <- [fun write_header/2,
                      fun write_api/2,
                      fun export_schema/2
                     ]
        ],
        ok
    after
        file:close(File)
    end.

write_header(Out, _) ->
    Out(["%%% DO NOT EDIT, this file was generated.~n"
         "-include_lib(\"ecapnp/include/ecapnp.hrl\").~n"]).

write_api(Out, #schema{ node=#node{ name=Name } }) ->
    {ok, Stubs} = file:read_file(
                    filename:join(
                      code:priv_dir(ecapnp), 
                      "schema_api_stub.hrl")),
    Api = lists:foldl(
            fun ({Re, R}, Subject) ->
                    re:replace(Subject, Re, R, [global])
            end, Stubs, 
            [{"_name_", atom_to_list(Name)}
            ]),
    Out(["~s~n", Api]).

export_schema(Out, #schema{ node=Node, types=Types }) ->
    I = 4,
    Out(["~p(schema) ->~n"
         "  #schema{~n"
         "    node=",
         Node#node.name]),
    export_item(Node, Out, I),
    export_list("types", Types, Out, I),
    Out(["}.~n"]).

export_list(_Label, [], _Out, _Indent) -> ok;
export_list(Label, List, Out, Indent) ->
    I = Indent + 2,
    Out([",~n~*s~s=~n~*s[", Indent, "", Label, I, ""]),
    export_items(List, Out, {first, I + 1}),
    Out(["~n~*s]", I, ""]).

export_items([Item|List], Out, {first, Indent}) ->
    export_item(Item, Out, Indent),
    export_items(List, Out, Indent);
export_items([Item|List], Out, Indent) ->
    Out([",~n~*s", Indent, ""]),
    export_item(Item, Out, Indent),
    export_items(List, Out, Indent);
export_items([], _, _) -> ok.

export_item({Tag, Type}, Out, Indent) 
  when is_tuple(Type), is_atom(element(1, Type)) ->
    I = Indent + 1,
    Out(["{~p,~n~*s", Tag, I, ""]),
    export_item(Type, Out, I),
    Out(["}"]);
export_item(#node{ id=Id, source=Src, name=Name }, Out, Indent) ->
    I = Indent + 2,
    Out(["#node{ %% 0x~.16b~n~*s"
         "name=~p, id=~b, source= ~p }",
         Id, I, "", Name, Id, Src]);
export_item(#struct{ node=Node, dsize=DSize, psize=PSize, esize=ESize,
                     fields=Fields, types=Types, union_field=Union },
            Out, Indent) ->
    I = Indent + 2,
    Out(["#struct{~n~*s"
         "node=", I, ""]),
    export_item(Node, Out, I),
    Out([",~n~*s"
         "dsize=~p, psize=~p, esize=~p,~n~*s"
         "union_field=",
         I, "", DSize, PSize, ESize,
         I, ""]),
    export_item(Union, Out, I),
    export_list("fields", Fields, Out, I),
    export_list("types", Types, Out, I),
    Out(["}"]);
export_item(#enum{ node=Node, values=Values, types=Types },
            Out, Indent) ->
    I = Indent + 2,
    Out(["#enum{~n~*s"
         "node=", I, ""]),
    export_item(Node, Out, I),
    export_list("values", Values, Out, I),
    export_list("types", Types, Out, I),
    Out(["}"]);
export_item(#interface{ node=Node }, Out, Indent) ->
    I = Indent + 2,
    Out(["#interface{ %% NYI..~n~*snode=", I, ""]),
    export_item(Node, Out, I),
    Out(["}"]);
export_item(#const{ node=Node }, Out, Indent) ->
    I = Indent + 2,
    Out(["#const{~n~*s"
         "node=", I, ""]),
    export_item(Node, Out, I),
    Out(["}"]);
export_item(#annotation{ node=Node }, Out, Indent) ->
    I = Indent + 2,
    Out(["#annotation{ %% NYI..~n~*snode=", I, ""]),
    export_item(Node, Out, I),
    Out(["}"]);
export_item(#data{ type={union, L}, align=A }, Out, Indent) ->
    I = Indent + 2,
    Out(["#data{ align=~p, type=~n~*s"
         "{union,~n~*s[",
         A, I, "", I + 2, ""]),
    export_items(L, Out, {first, I + 3}),
    Out(["~n~*s]} }", I, ""]);
export_item(#data{ type=T, align=A, default=D }, Out, Indent) ->
    Out(["#data{ type=~p, align=~p,~n~*s"
         "       default= ~p }", T, A, Indent, "", D]);
export_item(#ptr{ type=T, idx=I, default=D }, Out, Indent) ->
    Out(["#ptr{ type=~p, idx=~p,~n~*s"
         "      default= ~p }", T, I, Indent, "", D]);
export_item(#group{ id=Id }, Out, _Indent) ->
    Out(["#group{ id=~p }", Id]);
export_item(Item, Out, _Indent) ->
    Out(["~p", Item]).

get_output_filename(Src)
  when is_binary(Src) ->
    <<Src/binary, ".hrl">>.

create_output_file(FileName) ->
    ok = filelib:ensure_dir(FileName),
    file:open(FileName, [write]).

compile_root(Root) ->
    Nodes = [compile_node(N) || N <- schema(get, nodes, Root)],
    Files = schema(get, requestedFiles, Root),
    [link_node(schema(get, id, File), root, Nodes) || File <- Files].

compile_node(Node) ->
    {schema(get, id, Node),
     {Node, compile_node(
              schema(get, Node),
              #node{
                 id = schema(get, id, Node),
                 source = schema(get, displayName, Node)}
             )
     }}.

compile_node(file, Node) ->
    #schema{ node = Node };
compile_node({struct, Struct}, Node) ->
    {Fields, Union} = lists:partition(
                        fun (F) ->
                                16#ffff == schema(get, discriminantValue, F)
                        end,
                        schema(get, fields, Struct)),
    #struct{ node = Node,
             dsize = schema(get, dataWordCount, Struct),
             psize = schema(get, pointerCount, Struct),
             esize = schema(get, preferredListEncoding, Struct),
             fields = [compile_struct_field(M)
                       || M <- Fields],
             union_field = case schema(get, discriminantCount, Struct) of
                               0 -> none;
                               _ -> data_field(
                                      {{union,
                                        [compile_struct_field(F) || F <- Union]}, 16},
                                      schema(get, discriminantOffset, Struct), {union, 0})
                           end
           };
compile_node({enum, Enum}, Node) ->
    #enum{ node = Node,
           values =
               [binary_to_atom(schema(get, name, E), latin1) 
                || E <- schema(get, enumerants, Enum)]
         };
compile_node({interface, _Interface}, Node) ->
    #interface{ node = Node };
compile_node({const, _Const}, Node) ->
    #const{ node = Node };
compile_node({annotation, _Annotation}, Node) ->
    #annotation{ node = Node };
compile_node({What, _}, Node) ->
    throw({unknown_node, What, Node}).

compile_struct_field(Field) ->
    {binary_to_atom(schema(get, name, Field), latin1),
     compile_struct_field_type(schema(get, Field))}.

compile_struct_field_type({slot, Field}) ->
    compile_field(Field);
compile_struct_field_type({group, Group}) ->
    #group{ id=schema(get, typeId, Group) }.

compile_field(Field) ->
    Offset = schema(get, offset, Field),
    Default = schema(get, defaultValue, Field),
    case capnp_type_info(schema(get, schema(get, type, Field))) of
        {data_field, DataType} -> data_field(DataType, Offset, Default);
        {ptr_field, PtrType} -> ptr_field(PtrType, Offset, Default)
    end.

data_field(void, _Offset, _Default) -> void;
data_field({Type, 1}, Offset, Default) ->
    %% compensate for erlangs big endian bit streams.. yuck!
    data_field({Type, 8}, (Offset div 8) + ((7 - (Offset rem 8))/8), Default);
data_field({Type, Size}, Offset, Default) ->
    %% convert alignment to integer (Size * Offset should never be a fraction)
    #data{ type=Type, align=round(Size * Offset), default=default_value(Type, Default) }.

ptr_field(Type, Index, Default) ->
    #ptr{ type=Type, idx=Index, default=default_value(Type, Default) }.

default_value(Type, #object{ type=#node{ name='Value' } }=Object) ->
    default_value(Type, schema(get, Object));
default_value({struct, _Type}, {struct, #object{ dsize=DSize, psize=_PSize }=Object}) ->
    {ecapnp_obj:data_segment(0, DSize, Object), []}; %% todo: get list of pointer data..
default_value({Type, _}, {Type, Value}) -> Value;
default_value(Type, {Type, Value}) -> Value;
default_value(Type, Value) -> throw({value_type_mismatch, Type, Value}).


capnp_type_info(void) -> {data_field, void};
capnp_type_info(bool) -> {data_field, {bool, 1}};
capnp_type_info(int8) -> {data_field, {int8, 8}};
capnp_type_info(int16) -> {data_field, {int16, 16}};
capnp_type_info(int32) -> {data_field, {int32, 32}};
capnp_type_info(int64) -> {data_field, {int64, 64}};
capnp_type_info(uint8) -> {data_field, {uint8, 8}};
capnp_type_info(uint16) -> {data_field, {uint16, 16}};
capnp_type_info(uint32) -> {data_field, {uint32, 32}};
capnp_type_info(uint64) -> {data_field, {uint64, 64}};
capnp_type_info(float32) -> {data_field, {float32, 32}};
capnp_type_info(float64) -> {data_field, {float64, 64}};
capnp_type_info(text) -> {ptr_field, text};
capnp_type_info(data) -> {ptr_field, data};
capnp_type_info(object) -> {ptr_field, object};
capnp_type_info({list, List}) -> {ptr_field, {list, list_field_type(List)}};
capnp_type_info({enum, Enum}) -> {data_field, {{enum, schema(get, typeId, Enum)}, 16}};
capnp_type_info({RefT, Obj})
  when RefT == struct; RefT == interface ->
    {ptr_field, {RefT, schema(get, typeId, Obj)}};
capnp_type_info(Other) -> throw({unknown_capnp_type, Other}).
    
list_field_type(List) ->
    Type = schema(get, elementType, List),
    case capnp_type_info(schema(get, Type)) of
        {data_field, {T, _}} -> T;
        {_, T} -> T
    end.


link_node(Id, NodeName, Nodes) ->
    {Node, Schema} = proplists:get_value(Id, Nodes),
    NestedNodes = [begin
                       Name = binary_to_atom(schema(get, name, N), latin1),
                       link_node(schema(get, id, N), Name, Nodes)
                   end || N <- schema(get, nestedNodes, Node)],
    Groups = case schema(get, Node) of
                 {struct, O} ->
                     lists:foldl(
                       fun(F, G) ->
                               case schema(get, F) of
                                   {group, Group} ->
                                       Name = binary_to_atom(schema(get, name, F), latin1),
                                       [link_node(schema(get, typeId, Group), Name, Nodes)|G];
                                   _ -> G
                               end
                       end,
                       [],
                       schema(get, fields, O));
                 _ -> []
             end,
    Types = NestedNodes ++ Groups,
    case Schema of
        #schema{ node=N }=S
          when NodeName == root ->
            S#schema{ node=N#node{ name=schema_name(N) },
                      types=Types };
        #struct{ node=N }=S ->
            S#struct{ node=N#node{ name=NodeName },
                      types=Types };
        #enum{ node=N }=E ->
            E#enum{ node=N#node{ name=NodeName },
                    types=Types };
        #interface{ node=N }=I ->
            I#interface{ node=N#node{ name=NodeName } };
        #const{ node=N }=C ->
            C#const{ node=N#node{ name=NodeName } };
        #annotation{ node=N }=A ->
            A#annotation{ node=N#node{ name=NodeName } }
    end.

schema_name(#node{ source=Src }) ->
    binary_to_atom(filename:basename(Src, ".capnp"), latin1).
