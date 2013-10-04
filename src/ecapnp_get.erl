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

-module(ecapnp_get).
-author("Andreas Stenius <kaos@astekk.se>").

-export([root/3, field/2, union/1, ref_data/3]).

-include("ecapnp.hrl").


%% ===================================================================
%% API functions
%% ===================================================================

root(Type, Schema, Segments) ->
    {ok, ecapnp_obj:from_data(
           #msg{
              schema=Schema,
              alloc=[size(S) || S <- Segments],
              data=Segments
             },
           Type)}.

%% Lookup field value in object
field(FieldName, Object) ->
    read_field(
      ecapnp_obj:field(FieldName, Object),
      Object#object.ref).

union(#object{ type=#struct{ union_field=none }}=Object) ->
    throw({no_unnamed_union_in_object, Object});
union(#object{ ref=Ref, type=#struct{ union_field=Union }}) ->
    read_field(Union, Ref).

ref_data(Type, #object{ ref=Ref }, Default) ->
    ref_data(Type, Ref, Default);
ref_data(Type, Ref, Default) ->
    read_ptr(#ptr{ type=Type, default=Default }, Ref).


%% ===================================================================
%% internal functions
%% ===================================================================

read_field(#data{ type=Type, align=Align, default=Default }=D, StructRef) ->
    case Type of
        {enum, EnumType} ->
            {ok, #enum{ values=Values }}
                = ecapnp_schema:lookup(EnumType, StructRef),
            Tag = read_field(D#data{ type=uint16 }, StructRef),
            case lists:keyfind(Tag, 1, Values) of
                {Tag, Value} -> Value;
                false -> Tag
            end;
        {union, Fields} ->
            Tag = read_field(D#data{ type=uint16 }, StructRef),
            case lists:keyfind(Tag, 1, Fields) of
                {Tag, FieldName, void} -> FieldName;
                {Tag, FieldName, Field} ->
                    {FieldName, read_field(Field, StructRef)}
            end;
        Type ->
            Size = ecapnp_val:size(Type),
            ecapnp_val:get(
              Type, 
              ecapnp_ref:read_struct_data(Align, Size, StructRef),
              Default)
    end;
read_field(#ptr{ idx=Idx }=Ptr, StructRef) ->
    Ref = ecapnp_ref:read_struct_ptr(Idx, StructRef),
    read_ptr(Ptr, Ref);
read_field(#group{ id=Type }, Ref) ->
    ecapnp_obj:from_ref(Ref, Type).

read_ptr(#ptr{ type=Type, default=Default }, Ref) ->
    case Type of
        text -> ecapnp_ref:read_text(Ref, Default);
        data -> ecapnp_ref:read_data(Ref, Default);
        object -> read_obj(Ref, object, Default);
        {struct, StructType} -> read_obj(Ref, StructType, Default);
        {list, ElementType} ->
            case ecapnp_ref:read_list(Ref, undefined) of
                undefined -> Default;
                Refs when is_record(hd(Refs), ref) ->
                    [read_ptr(#ptr{ type=ElementType }, R)
                     || R <- Refs];
                Values ->
                    [ecapnp_val:get(Type, Data)
                     || Data <- Values]
            end
    end.

read_obj(#ref{ kind=null, data=Data }, Type, Default0) ->
    Default = if Default0 == null, Type /= object ->
                      {ok, #struct{
                              dsize=DSize,
                              psize=PSize
                             }} = ecapnp_schema:lookup(Type, Data),
                      <<0:32/integer,
                        DSize:16/integer-unsigned-little,
                        PSize:16/integer-unsigned-little,
                        0:DSize/integer-unit:64,
                        0:PSize/integer-unit:64>>;
                 is_atom(Default0) ->
                      <<0:64/integer>>;
                 true ->
                      Default0
              end,
    if is_binary(Default) ->
            ecapnp_obj:from_data({Data, Default}, Type);
       true ->
            Default
    end;
read_obj(Ref, Type, _) ->
    ecapnp_obj:from_ref(Ref, Type).
