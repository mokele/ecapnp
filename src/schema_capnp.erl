-file("schema.capnp", 1).

%% This file was generated 2014-04-03 12:41:55 UTC by ecapnp 0.2.
%% http://github.com/kaos/ecapnp
-module(schema_capnp).

-vsn(12195682960037147353).

-export([schema/1, 'Node'/0, 'Node'/1, '16610026722781537303'/0, '16050641862814319170'/0,
	 '17011813041836786320'/0, '12793219851699983392'/0, '16728431493453586831'/0,
	 '13063450714778629528'/0, '11430331134483579957'/0, 'Field'/0, 'Field'/1, '11145653318641710175'/0,
	 '10930602151629473554'/0, '13515537513213004774'/0, '14626792032033250577'/0,
	 '14133145859926553711'/0, 'Enumerant'/0, 'Enumerant'/1, '10919677598968879693'/0, 'Method'/0,
	 'Method'/1, '10736806783679155584'/0, 'Type'/0, 'Type'/1, '15020482145304562784'/0,
	 '17116997365232503999'/0, '12410354185295152851'/0, '11389172934837766057'/0,
	 '9792858745991129751'/0, 'Value'/0, 'Value'/1, '14853958794117909659'/0, 'Annotation'/0,
	 'Annotation'/1, '17422339044421236034'/0, 'ElementSize'/0, 'ElementSize'/1,
	 '15102134695616452902'/0, 'CodeGeneratorRequest'/0, 'CodeGeneratorRequest'/1,
	 '13818529054586492878'/0, '14981803260258615394'/0, '12560611460656617445'/0, root/0, root/1,
	 '12195682960037147353'/0]).

-types([{16610026722781537303, 'Node'}, {16050641862814319170, ['Node', 'NestedNode']},
	{17011813041836786320, ['Node', annotation]}, {12793219851699983392, ['Node', const]},
	{16728431493453586831, ['Node', interface]}, {13063450714778629528, ['Node', enum]},
	{11430331134483579957, ['Node', struct]}, {11145653318641710175, 'Field'},
	{10930602151629473554, ['Field', noDiscriminant]}, {13515537513213004774, ['Field', ordinal]},
	{14626792032033250577, ['Field', group]}, {14133145859926553711, ['Field', slot]},
	{10919677598968879693, 'Enumerant'}, {10736806783679155584, 'Method'},
	{15020482145304562784, 'Type'}, {17116997365232503999, ['Type', interface]},
	{12410354185295152851, ['Type', struct]}, {11389172934837766057, ['Type', enum]},
	{9792858745991129751, ['Type', list]}, {14853958794117909659, 'Value'},
	{17422339044421236034, 'Annotation'}, {15102134695616452902, 'ElementSize'},
	{13818529054586492878, 'CodeGeneratorRequest'},
	{14981803260258615394, ['CodeGeneratorRequest', 'RequestedFile']},
	{12560611460656617445, ['CodeGeneratorRequest', 'RequestedFile', 'Import']},
	{12195682960037147353, root}]).

-import('c++_capnp', ['13386661402618388268'/0]).

-file("/home/kaos/src/erl/libs/ecapnp/include/ecapnp_records.hrl", 1).

-record(schema_node,
	{module, name, id = 0, src = <<>>, kind = file, annotations = [], nodes = [], scope = 0}).

-type({{record, schema_node},
       [{typed_record_field, {record_field, 4, {atom, 4, module}},
	 {type, 4, union, [{atom, 4, undefined}, {type, 4, atom, []}]}},
	{typed_record_field, {record_field, 5, {atom, 5, name}},
	 {type, 5, union,
	  [{atom, 5, undefined}, {remote_type, 5, [{atom, 5, ecapnp}, {atom, 5, type_name}, []]}]}},
	{typed_record_field, {record_field, 6, {atom, 6, id}, {integer, 6, 0}},
	 {remote_type, 6, [{atom, 6, ecapnp}, {atom, 6, type_id}, []]}},
	{typed_record_field, {record_field, 7, {atom, 7, src}, {bin, 7, []}},
	 {remote_type, 7, [{atom, 7, ecapnp}, {atom, 7, text}, []]}},
	{typed_record_field, {record_field, 8, {atom, 8, kind}, {atom, 8, file}},
	 {remote_type, 8, [{atom, 8, ecapnp}, {atom, 8, schema_kind}, []]}},
	{typed_record_field, {record_field, 9, {atom, 9, annotations}, {nil, 9}}, {type, 9, list, []}},
	{typed_record_field, {record_field, 10, {atom, 10, nodes}, {nil, 10}},
	 {remote_type, 10, [{atom, 10, ecapnp}, {atom, 10, schema_nodes}, []]}},
	{typed_record_field, {record_field, 11, {atom, 11, scope}, {integer, 11, 0}},
	 {remote_type, 11, [{atom, 11, ecapnp}, {atom, 11, type_id}, []]}}],
       []}).

-record(struct, {dsize = 0, psize = 0, esize = inlineComposite, union_field = none, fields = []}).

-type({{record, struct},
       [{typed_record_field, {record_field, 16, {atom, 16, dsize}, {integer, 16, 0}},
	 {remote_type, 16, [{atom, 16, ecapnp}, {atom, 16, word_count}, []]}},
	{typed_record_field, {record_field, 17, {atom, 17, psize}, {integer, 17, 0}},
	 {remote_type, 17, [{atom, 17, ecapnp}, {atom, 17, ptr_count}, []]}},
	{typed_record_field, {record_field, 18, {atom, 18, esize}, {atom, 18, inlineComposite}},
	 {remote_type, 18, [{atom, 18, ecapnp}, {atom, 18, element_size}, []]}},
	{typed_record_field, {record_field, 19, {atom, 19, union_field}, {atom, 19, none}},
	 {type, 19, union,
	  [{atom, 19, none}, {remote_type, 19, [{atom, 19, ecapnp}, {atom, 19, field_type}, []]}]}},
	{typed_record_field, {record_field, 20, {atom, 20, fields}, {nil, 20}},
	 {remote_type, 20, [{atom, 20, ecapnp}, {atom, 20, struct_fields}, []]}}],
       []}).

-record(enum, {values = []}).

-type({{record, enum},
       [{typed_record_field, {record_field, 25, {atom, 25, values}, {nil, 25}},
	 {remote_type, 25, [{atom, 25, ecapnp}, {atom, 25, enum_values}, []]}}],
       []}).

-record(interface, {extends = [], methods = [], struct}).

-type({{record, interface},
       [{typed_record_field, {record_field, 30, {atom, 30, extends}, {nil, 30}}, {type, 30, list, []}},
	{typed_record_field, {record_field, 31, {atom, 31, methods}, {nil, 31}}, {type, 31, list, []}},
	{typed_record_field, {record_field, 34, {atom, 34, struct}},
	 {type, 34, union,
	  [{atom, 34, undefined}, {remote_type, 34, [{atom, 34, ecapnp}, {atom, 34, struct}, []]}]}}],
       []}).

-record(const, {field}).

-record(annotation, {type, targets = []}).

-type({{record, annotation},
       [{record_field, 44, {atom, 44, type}},
	{typed_record_field, {record_field, 45, {atom, 45, targets}, {nil, 45}},
	 {type, 45, list, [{type, 45, atom, []}]}}],
       []}).

-record(field, {name, kind, annotations = []}).

-record(ptr, {type, idx = 0, default = null}).

-type({{record, ptr},
       [{typed_record_field, {record_field, 57, {atom, 57, type}},
	 {type, 57, union, [{atom, 57, undefined}, {type, 57, term, []}]}},
	{typed_record_field, {record_field, 58, {atom, 58, idx}, {integer, 58, 0}},
	 {remote_type, 58, [{atom, 58, ecapnp}, {atom, 58, ptr_index}, []]}},
	{typed_record_field, {record_field, 59, {atom, 59, default}, {atom, 59, null}},
	 {remote_type, 59, [{atom, 59, ecapnp}, {atom, 59, value}, []]}}],
       []}).

-record(data, {type, align = 0, default}).

-type({{record, data},
       [{typed_record_field, {record_field, 63, {atom, 63, type}},
	 {type, 63, union, [{atom, 63, undefined}, {type, 63, term, []}]}},
	{typed_record_field, {record_field, 64, {atom, 64, align}, {integer, 64, 0}},
	 {remote_type, 64, [{atom, 64, ecapnp}, {atom, 64, bit_count}, []]}},
	{typed_record_field, {record_field, 65, {atom, 65, default}},
	 {type, 65, union,
	  [{atom, 65, undefined}, {remote_type, 65, [{atom, 65, ecapnp}, {atom, 65, value}, []]}]}}],
       []}).

-record(group, {id = 0}).

-type({{record, group},
       [{typed_record_field, {record_field, 69, {atom, 69, id}, {integer, 69, 0}},
	 {remote_type, 69, [{atom, 69, ecapnp}, {atom, 69, type_id}, []]}}],
       []}).

-record(method, {name, paramType, resultType}).

-record(ref, {segment, pos = -1, offset = 0, kind = null, data}).

-type({{record, ref},
       [{typed_record_field, {record_field, 83, {atom, 83, segment}},
	 {type, 83, union,
	  [{atom, 83, undefined}, {remote_type, 83, [{atom, 83, ecapnp}, {atom, 83, segment_id}, []]}]}},
	{typed_record_field, {record_field, 84, {atom, 84, pos}, {op, 84, '-', {integer, 84, 1}}},
	 {remote_type, 84, [{atom, 84, ecapnp}, {atom, 84, segment_pos}, []]}},
	{typed_record_field, {record_field, 85, {atom, 85, offset}, {integer, 85, 0}},
	 {remote_type, 85, [{atom, 85, ecapnp}, {atom, 85, segment_offset}, []]}},
	{typed_record_field, {record_field, 86, {atom, 86, kind}, {atom, 86, null}},
	 {remote_type, 86, [{atom, 86, ecapnp}, {atom, 86, ref_kind}, []]}},
	{typed_record_field, {record_field, 87, {atom, 87, data}},
	 {type, 87, union, [{atom, 87, undefined}, {type, 87, pid, []}]}}],
       []}).

-record(struct_ref, {dsize = 0, psize = 0}).

-type({{record, struct_ref},
       [{typed_record_field, {record_field, 97, {atom, 97, dsize}, {integer, 97, 0}},
	 {remote_type, 97, [{atom, 97, ecapnp}, {atom, 97, word_count}, []]}},
	{typed_record_field, {record_field, 97, {atom, 97, psize}, {integer, 97, 0}},
	 {remote_type, 97, [{atom, 97, ecapnp}, {atom, 97, ptr_count}, []]}}],
       []}).

-record(list_ref, {size = empty, count = 0}).

-type({{record, list_ref},
       [{typed_record_field, {record_field, 101, {atom, 101, size}, {atom, 101, empty}},
	 {remote_type, 101, [{atom, 101, ecapnp}, {atom, 101, element_size}, []]}},
	{typed_record_field, {record_field, 102, {atom, 102, count}, {integer, 102, 0}},
	 {type, 102, non_neg_integer, []}}],
       []}).

-record(far_ref, {segment = 0, double_far = false}).

-type({{record, far_ref},
       [{typed_record_field, {record_field, 106, {atom, 106, segment}, {integer, 106, 0}},
	 {type, 106, non_neg_integer, []}},
	{typed_record_field, {record_field, 107, {atom, 107, double_far}, {atom, 107, false}},
	 {type, 107, boolean, []}}],
       []}).

-record(interface_ref, {dsize = 0, psize = 0}).

-type({{record, interface_ref},
       [{typed_record_field, {record_field, 111, {atom, 111, dsize}, {integer, 111, 0}},
	 {remote_type, 111, [{atom, 111, ecapnp}, {atom, 111, word_count}, []]}},
	{typed_record_field, {record_field, 111, {atom, 111, psize}, {integer, 111, 0}},
	 {remote_type, 111, [{atom, 111, ecapnp}, {atom, 111, ptr_count}, []]}}],
       []}).

-record(object, {ref = null, schema = object}).

-type({{record, object},
       [{typed_record_field, {record_field, 115, {atom, 115, ref}, {atom, 115, null}},
	 {remote_type, 115, [{atom, 115, ecapnp}, {atom, 115, ref}, []]}},
	{typed_record_field, {record_field, 116, {atom, 116, schema}, {atom, 116, object}},
	 {type, 116, union,
	  [{atom, 116, object}, {remote_type, 116, [{atom, 116, ecapnp}, {atom, 116, schema_node}, []]}]}}],
       []}).

-record(request, {method, param, interface}).

-type({{record, request},
       [{typed_record_field, {record_field, 124, {atom, 124, method}},
	 {type, 124, union,
	  [{atom, 124, undefined}, {remote_type, 124, [{atom, 124, ecapnp}, {atom, 124, field_name}, []]}]}},
	{typed_record_field, {record_field, 125, {atom, 125, param}},
	 {type, 125, union,
	  [{atom, 125, undefined}, {remote_type, 125, [{atom, 125, ecapnp}, {atom, 125, object}, []]}]}},
	{typed_record_field, {record_field, 126, {atom, 126, interface}},
	 {type, 126, union,
	  [{atom, 126, undefined},
	   {remote_type, 126, [{atom, 126, ecapnp}, {atom, 126, schema_node}, []]}]}}],
       []}).

-record(msg, {schema, alloc = [], data = []}).

-type({{record, msg},
       [{typed_record_field, {record_field, 131, {atom, 131, schema}},
	 {type, 131, union,
	  [{atom, 131, undefined}, {remote_type, 131, [{atom, 131, ecapnp}, {atom, 131, schema}, []]}]}},
	{typed_record_field, {record_field, 132, {atom, 132, alloc}, {nil, 132}},
	 {type, 132, list, [{type, 132, integer, []}]}},
	{typed_record_field, {record_field, 133, {atom, 133, data}, {nil, 133}},
	 {remote_type, 133, [{atom, 133, ecapnp}, {atom, 133, message}, []]}}],
       []}).

-file("schema.capnp", 1).

schema(16610026722781537303) -> '16610026722781537303'();
schema('Node') -> '16610026722781537303'();
schema(['Node']) -> '16610026722781537303'();
schema(16050641862814319170) -> '16050641862814319170'();
schema(['Node', 'NestedNode']) -> '16050641862814319170'();
schema(17011813041836786320) -> '17011813041836786320'();
schema(['Node', annotation]) -> '17011813041836786320'();
schema(12793219851699983392) -> '12793219851699983392'();
schema(['Node', const]) -> '12793219851699983392'();
schema(16728431493453586831) -> '16728431493453586831'();
schema(['Node', interface]) -> '16728431493453586831'();
schema(13063450714778629528) -> '13063450714778629528'();
schema(['Node', enum]) -> '13063450714778629528'();
schema(11430331134483579957) -> '11430331134483579957'();
schema(['Node', struct]) -> '11430331134483579957'();
schema(11145653318641710175) -> '11145653318641710175'();
schema('Field') -> '11145653318641710175'();
schema(['Field']) -> '11145653318641710175'();
schema(10930602151629473554) -> '10930602151629473554'();
schema(['Field', noDiscriminant]) -> '10930602151629473554'();
schema(13515537513213004774) -> '13515537513213004774'();
schema(['Field', ordinal]) -> '13515537513213004774'();
schema(14626792032033250577) -> '14626792032033250577'();
schema(['Field', group]) -> '14626792032033250577'();
schema(14133145859926553711) -> '14133145859926553711'();
schema(['Field', slot]) -> '14133145859926553711'();
schema(10919677598968879693) -> '10919677598968879693'();
schema('Enumerant') -> '10919677598968879693'();
schema(['Enumerant']) -> '10919677598968879693'();
schema(10736806783679155584) -> '10736806783679155584'();
schema('Method') -> '10736806783679155584'();
schema(['Method']) -> '10736806783679155584'();
schema(15020482145304562784) -> '15020482145304562784'();
schema('Type') -> '15020482145304562784'();
schema(['Type']) -> '15020482145304562784'();
schema(17116997365232503999) -> '17116997365232503999'();
schema(['Type', interface]) -> '17116997365232503999'();
schema(12410354185295152851) -> '12410354185295152851'();
schema(['Type', struct]) -> '12410354185295152851'();
schema(11389172934837766057) -> '11389172934837766057'();
schema(['Type', enum]) -> '11389172934837766057'();
schema(9792858745991129751) -> '9792858745991129751'();
schema(['Type', list]) -> '9792858745991129751'();
schema(14853958794117909659) -> '14853958794117909659'();
schema('Value') -> '14853958794117909659'();
schema(['Value']) -> '14853958794117909659'();
schema(17422339044421236034) -> '17422339044421236034'();
schema('Annotation') -> '17422339044421236034'();
schema(['Annotation']) -> '17422339044421236034'();
schema(15102134695616452902) -> '15102134695616452902'();
schema('ElementSize') -> '15102134695616452902'();
schema(['ElementSize']) -> '15102134695616452902'();
schema(13818529054586492878) -> '13818529054586492878'();
schema('CodeGeneratorRequest') -> '13818529054586492878'();
schema(['CodeGeneratorRequest']) -> '13818529054586492878'();
schema(14981803260258615394) -> '14981803260258615394'();
schema(['CodeGeneratorRequest', 'RequestedFile']) -> '14981803260258615394'();
schema(12560611460656617445) -> '12560611460656617445'();
schema(['CodeGeneratorRequest', 'RequestedFile', 'Import']) -> '12560611460656617445'();
schema(12195682960037147353) -> '12195682960037147353'();
schema(root) -> '12195682960037147353'();
schema([root]) -> '12195682960037147353'();
%% Imported from c++_capnp
schema(13386661402618388268) -> '13386661402618388268'();
schema(namespace) -> '13386661402618388268'();
schema([namespace]) -> '13386661402618388268'();
schema(_) -> undefined.

root() -> '12195682960037147353'().

root([]) -> '12195682960037147353'().

'12195682960037147353'() ->
    #schema_node{module = schema_capnp, name = root, id = 12195682960037147353, scope = 0,
		 src = <<"schema.capnp">>, annotations = [{13386661402618388268, <<"capnp::schema">>}], kind = file,
		 nodes =
		     [16610026722781537303,  %% Node
		      11145653318641710175,  %% Field
		      10919677598968879693,  %% Enumerant
		      10736806783679155584,  %% Method
		      15020482145304562784,  %% Type
		      14853958794117909659,  %% Value
		      17422339044421236034,  %% Annotation
		      15102134695616452902,  %% ElementSize
		      13818529054586492878]}.  %% CodeGeneratorRequest

'CodeGeneratorRequest'() -> '13818529054586492878'().

'CodeGeneratorRequest'(['RequestedFile']) -> '14981803260258615394'();
'CodeGeneratorRequest'(['RequestedFile', 'Import']) -> '12560611460656617445'();
'CodeGeneratorRequest'([]) -> '13818529054586492878'().

'13818529054586492878'() ->
    #schema_node{module = schema_capnp, name = 'CodeGeneratorRequest', id = 13818529054586492878,
		 scope = 12195682960037147353, src = <<"schema.capnp:CodeGeneratorRequest">>,
		 kind =
		     #struct{dsize = 0, psize = 2, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = nodes,
					 kind =
					     #ptr{type = {list, {struct, 16610026722781537303}}, idx = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = requestedFiles,
					 kind =
					     #ptr{type = {list, {struct, 14981803260258615394}}, idx = 1,
						  default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]},
		 nodes =
		     [14981803260258615394]}.  %% RequestedFile

'14981803260258615394'() ->
    #schema_node{module = schema_capnp, name = ['CodeGeneratorRequest', 'RequestedFile'],
		 id = 14981803260258615394, scope = 13818529054586492878,
		 src = <<"schema.capnp:CodeGeneratorRequest.RequestedFile">>,
		 kind =
		     #struct{dsize = 1, psize = 2, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = id, kind = #data{type = uint64, align = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = filename, kind = #ptr{type = text, idx = 0, default = <<"">>}},
				  #field{name = imports,
					 kind =
					     #ptr{type = {list, {struct, 12560611460656617445}}, idx = 1,
						  default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]},
		 nodes =
		     [12560611460656617445]}.  %% Import

'12560611460656617445'() ->
    #schema_node{module = schema_capnp, name = ['CodeGeneratorRequest', 'RequestedFile', 'Import'],
		 id = 12560611460656617445, scope = 14981803260258615394,
		 src = <<"schema.capnp:CodeGeneratorRequest.RequestedFile.Import">>,
		 kind =
		     #struct{dsize = 1, psize = 1, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = id, kind = #data{type = uint64, align = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = name, kind = #ptr{type = text, idx = 0, default = <<"">>}}]}}.

'ElementSize'() -> '15102134695616452902'().

'ElementSize'([]) -> '15102134695616452902'().

'15102134695616452902'() ->
    #schema_node{module = schema_capnp, name = 'ElementSize', id = 15102134695616452902,
		 scope = 12195682960037147353, src = <<"schema.capnp:ElementSize">>,
		 kind =
		     #enum{values =
			       [{0, empty}, {1, bit}, {2, byte}, {3, twoBytes}, {4, fourBytes}, {5, eightBytes}, {6, pointer},
				{7, inlineComposite}]}}.

'Annotation'() -> '17422339044421236034'().

'Annotation'([]) -> '17422339044421236034'().

'17422339044421236034'() ->
    #schema_node{module = schema_capnp, name = 'Annotation', id = 17422339044421236034,
		 scope = 12195682960037147353, src = <<"schema.capnp:Annotation">>,
		 kind =
		     #struct{dsize = 1, psize = 1, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = id, kind = #data{type = uint64, align = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = value,
					 kind =
					     #ptr{type = {struct, 14853958794117909659}, idx = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'Value'() -> '14853958794117909659'().

'Value'([]) -> '14853958794117909659'().

'14853958794117909659'() ->
    #schema_node{module = schema_capnp, name = 'Value', id = 14853958794117909659,
		 scope = 12195682960037147353, src = <<"schema.capnp:Value">>,
		 kind =
		     #struct{dsize = 2, psize = 1, esize = inlineComposite,
			     union_field =
				 #data{type =
					   {union,
					    [{0, void, #field{name = void, kind = void}},
					     {1, bool, #field{name = bool, kind = #data{type = bool, align = 23, default = <<0:1>>}}},
					     {2, int8, #field{name = int8, kind = #data{type = int8, align = 16, default = <<0>>}}},
					     {3, int16, #field{name = int16, kind = #data{type = int16, align = 16, default = <<0, 0>>}}},
					     {4, int32, #field{name = int32, kind = #data{type = int32, align = 32, default = <<0, 0, 0, 0>>}}},
					     {5, int64,
					      #field{name = int64, kind = #data{type = int64, align = 64, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}},
					     {6, uint8, #field{name = uint8, kind = #data{type = uint8, align = 16, default = <<0>>}}},
					     {7, uint16, #field{name = uint16, kind = #data{type = uint16, align = 16, default = <<0, 0>>}}},
					     {8, uint32,
					      #field{name = uint32, kind = #data{type = uint32, align = 32, default = <<0, 0, 0, 0>>}}},
					     {9, uint64,
					      #field{name = uint64,
						     kind = #data{type = uint64, align = 64, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}},
					     {10, float32,
					      #field{name = float32, kind = #data{type = float32, align = 32, default = <<0, 0, 0, 0>>}}},
					     {11, float64,
					      #field{name = float64,
						     kind = #data{type = float64, align = 64, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}},
					     {12, text, #field{name = text, kind = #ptr{type = text, idx = 0, default = <<"">>}}},
					     {13, data, #field{name = data, kind = #ptr{type = data, idx = 0, default = <<>>}}},
					     {14, list,
					      #field{name = list, kind = #ptr{type = object, idx = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}},
					     {15, enum, #field{name = enum, kind = #data{type = uint16, align = 16, default = <<0, 0>>}}},
					     {16, struct,
					      #field{name = struct, kind = #ptr{type = object, idx = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}},
					     {17, interface, #field{name = interface, kind = void}},
					     {18, anyPointer,
					      #field{name = anyPointer,
						     kind = #ptr{type = object, idx = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}}]},
				       align = 0, default = <<0, 0>>},
			     fields = []}}.

'Type'() -> '15020482145304562784'().

'Type'([interface]) -> '17116997365232503999'();
'Type'([struct]) -> '12410354185295152851'();
'Type'([enum]) -> '11389172934837766057'();
'Type'([list]) -> '9792858745991129751'();
'Type'([]) -> '15020482145304562784'().

'15020482145304562784'() ->
    #schema_node{module = schema_capnp, name = 'Type', id = 15020482145304562784,
		 scope = 12195682960037147353, src = <<"schema.capnp:Type">>,
		 kind =
		     #struct{dsize = 2, psize = 1, esize = inlineComposite,
			     union_field =
				 #data{type =
					   {union,
					    [{0, void, #field{name = void, kind = void}}, {1, bool, #field{name = bool, kind = void}},
					     {2, int8, #field{name = int8, kind = void}}, {3, int16, #field{name = int16, kind = void}},
					     {4, int32, #field{name = int32, kind = void}}, {5, int64, #field{name = int64, kind = void}},
					     {6, uint8, #field{name = uint8, kind = void}}, {7, uint16, #field{name = uint16, kind = void}},
					     {8, uint32, #field{name = uint32, kind = void}}, {9, uint64, #field{name = uint64, kind = void}},
					     {10, float32, #field{name = float32, kind = void}},
					     {11, float64, #field{name = float64, kind = void}}, {12, text, #field{name = text, kind = void}},
					     {13, data, #field{name = data, kind = void}},
					     {14, list, #field{name = list, kind = #group{id = 9792858745991129751}}},
					     {15, enum, #field{name = enum, kind = #group{id = 11389172934837766057}}},
					     {16, struct, #field{name = struct, kind = #group{id = 12410354185295152851}}},
					     {17, interface, #field{name = interface, kind = #group{id = 17116997365232503999}}},
					     {18, anyPointer, #field{name = anyPointer, kind = void}}]},
				       align = 0, default = <<0, 0>>},
			     fields = []}}.

'17116997365232503999'() ->
    #schema_node{module = schema_capnp, name = ['Type', interface], id = 17116997365232503999,
		 scope = 15020482145304562784, src = <<"schema.capnp:Type.interface">>,
		 kind =
		     #struct{dsize = 2, psize = 1, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = typeId,
					 kind = #data{type = uint64, align = 64, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'12410354185295152851'() ->
    #schema_node{module = schema_capnp, name = ['Type', struct], id = 12410354185295152851,
		 scope = 15020482145304562784, src = <<"schema.capnp:Type.struct">>,
		 kind =
		     #struct{dsize = 2, psize = 1, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = typeId,
					 kind = #data{type = uint64, align = 64, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'11389172934837766057'() ->
    #schema_node{module = schema_capnp, name = ['Type', enum], id = 11389172934837766057,
		 scope = 15020482145304562784, src = <<"schema.capnp:Type.enum">>,
		 kind =
		     #struct{dsize = 2, psize = 1, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = typeId,
					 kind = #data{type = uint64, align = 64, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'9792858745991129751'() ->
    #schema_node{module = schema_capnp, name = ['Type', list], id = 9792858745991129751,
		 scope = 15020482145304562784, src = <<"schema.capnp:Type.list">>,
		 kind =
		     #struct{dsize = 2, psize = 1, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = elementType,
					 kind =
					     #ptr{type = {struct, 15020482145304562784}, idx = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'Method'() -> '10736806783679155584'().

'Method'([]) -> '10736806783679155584'().

'10736806783679155584'() ->
    #schema_node{module = schema_capnp, name = 'Method', id = 10736806783679155584,
		 scope = 12195682960037147353, src = <<"schema.capnp:Method">>,
		 kind =
		     #struct{dsize = 3, psize = 2, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = name, kind = #ptr{type = text, idx = 0, default = <<"">>}},
				  #field{name = codeOrder, kind = #data{type = uint16, align = 0, default = <<0, 0>>}},
				  #field{name = paramStructType,
					 kind = #data{type = uint64, align = 64, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = resultStructType,
					 kind = #data{type = uint64, align = 128, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = annotations,
					 kind =
					     #ptr{type = {list, {struct, 17422339044421236034}}, idx = 1,
						  default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'Enumerant'() -> '10919677598968879693'().

'Enumerant'([]) -> '10919677598968879693'().

'10919677598968879693'() ->
    #schema_node{module = schema_capnp, name = 'Enumerant', id = 10919677598968879693,
		 scope = 12195682960037147353, src = <<"schema.capnp:Enumerant">>,
		 kind =
		     #struct{dsize = 1, psize = 2, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = name, kind = #ptr{type = text, idx = 0, default = <<"">>}},
				  #field{name = codeOrder, kind = #data{type = uint16, align = 0, default = <<0, 0>>}},
				  #field{name = annotations,
					 kind =
					     #ptr{type = {list, {struct, 17422339044421236034}}, idx = 1,
						  default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'Field'() -> '11145653318641710175'().

'Field'([noDiscriminant]) -> '10930602151629473554'();
'Field'([ordinal]) -> '13515537513213004774'();
'Field'([group]) -> '14626792032033250577'();
'Field'([slot]) -> '14133145859926553711'();
'Field'([]) -> '11145653318641710175'().

'11145653318641710175'() ->
    #schema_node{module = schema_capnp, name = 'Field', id = 11145653318641710175,
		 scope = 12195682960037147353, src = <<"schema.capnp:Field">>,
		 kind =
		     #struct{dsize = 3, psize = 4, esize = inlineComposite,
			     union_field =
				 #data{type =
					   {union,
					    [{0, slot, #field{name = slot, kind = #group{id = 14133145859926553711}}},
					     {1, group, #field{name = group, kind = #group{id = 14626792032033250577}}}]},
				       align = 64, default = <<0, 0>>},
			     fields =
				 [#field{name = name, kind = #ptr{type = text, idx = 0, default = <<"">>}},
				  #field{name = codeOrder, kind = #data{type = uint16, align = 0, default = <<0, 0>>}},
				  #field{name = annotations,
					 kind =
					     #ptr{type = {list, {struct, 17422339044421236034}}, idx = 1, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = discriminantValue, kind = #data{type = uint16, align = 16, default = <<255, 255>>}},
				  #field{name = ordinal, kind = #group{id = 13515537513213004774}}]},
		 nodes =
		     [10930602151629473554]}.  %% noDiscriminant

'10930602151629473554'() ->
    #schema_node{module = schema_capnp, name = ['Field', noDiscriminant], id = 10930602151629473554,
		 scope = 11145653318641710175, src = <<"schema.capnp:Field.noDiscriminant">>,
		 kind = #const{field = #data{type = uint16, align = 0, default = <<255, 255>>}}}.

'13515537513213004774'() ->
    #schema_node{module = schema_capnp, name = ['Field', ordinal], id = 13515537513213004774,
		 scope = 11145653318641710175, src = <<"schema.capnp:Field.ordinal">>,
		 kind =
		     #struct{dsize = 3, psize = 4, esize = inlineComposite,
			     union_field =
				 #data{type =
					   {union,
					    [{0, implicit, #field{name = implicit, kind = void}},
					     {1, explicit,
					      #field{name = explicit, kind = #data{type = uint16, align = 96, default = <<0, 0>>}}}]},
				       align = 80, default = <<0, 0>>},
			     fields = []}}.

'14626792032033250577'() ->
    #schema_node{module = schema_capnp, name = ['Field', group], id = 14626792032033250577,
		 scope = 11145653318641710175, src = <<"schema.capnp:Field.group">>,
		 kind =
		     #struct{dsize = 3, psize = 4, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = typeId,
					 kind = #data{type = uint64, align = 128, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'14133145859926553711'() ->
    #schema_node{module = schema_capnp, name = ['Field', slot], id = 14133145859926553711,
		 scope = 11145653318641710175, src = <<"schema.capnp:Field.slot">>,
		 kind =
		     #struct{dsize = 3, psize = 4, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = offset, kind = #data{type = uint32, align = 32, default = <<0, 0, 0, 0>>}},
				  #field{name = type,
					 kind = #ptr{type = {struct, 15020482145304562784}, idx = 2, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = defaultValue,
					 kind = #ptr{type = {struct, 14853958794117909659}, idx = 3, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = hadExplicitDefault, kind = #data{type = bool, align = 135, default = <<0:1>>}}]}}.

'Node'() -> '16610026722781537303'().

'Node'(['NestedNode']) -> '16050641862814319170'();
'Node'([annotation]) -> '17011813041836786320'();
'Node'([const]) -> '12793219851699983392'();
'Node'([interface]) -> '16728431493453586831'();
'Node'([enum]) -> '13063450714778629528'();
'Node'([struct]) -> '11430331134483579957'();
'Node'([]) -> '16610026722781537303'().

'16610026722781537303'() ->
    #schema_node{module = schema_capnp, name = 'Node', id = 16610026722781537303,
		 scope = 12195682960037147353, src = <<"schema.capnp:Node">>,
		 kind =
		     #struct{dsize = 5, psize = 5, esize = inlineComposite,
			     union_field =
				 #data{type =
					   {union,
					    [{0, file, #field{name = file, kind = void}},
					     {1, struct, #field{name = struct, kind = #group{id = 11430331134483579957}}},
					     {2, enum, #field{name = enum, kind = #group{id = 13063450714778629528}}},
					     {3, interface, #field{name = interface, kind = #group{id = 16728431493453586831}}},
					     {4, const, #field{name = const, kind = #group{id = 12793219851699983392}}},
					     {5, annotation, #field{name = annotation, kind = #group{id = 17011813041836786320}}}]},
				       align = 96, default = <<0, 0>>},
			     fields =
				 [#field{name = id, kind = #data{type = uint64, align = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = displayName, kind = #ptr{type = text, idx = 0, default = <<"">>}},
				  #field{name = displayNamePrefixLength,
					 kind = #data{type = uint32, align = 64, default = <<0, 0, 0, 0>>}},
				  #field{name = scopeId,
					 kind = #data{type = uint64, align = 128, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = nestedNodes,
					 kind =
					     #ptr{type = {list, {struct, 16050641862814319170}}, idx = 1, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = annotations,
					 kind =
					     #ptr{type = {list, {struct, 17422339044421236034}}, idx = 2,
						  default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]},
		 nodes =
		     [16050641862814319170]}.  %% NestedNode

'16050641862814319170'() ->
    #schema_node{module = schema_capnp, name = ['Node', 'NestedNode'], id = 16050641862814319170,
		 scope = 16610026722781537303, src = <<"schema.capnp:Node.NestedNode">>,
		 kind =
		     #struct{dsize = 1, psize = 1, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = name, kind = #ptr{type = text, idx = 0, default = <<"">>}},
				  #field{name = id, kind = #data{type = uint64, align = 0, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'17011813041836786320'() ->
    #schema_node{module = schema_capnp, name = ['Node', annotation], id = 17011813041836786320,
		 scope = 16610026722781537303, src = <<"schema.capnp:Node.annotation">>,
		 kind =
		     #struct{dsize = 5, psize = 5, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = type,
					 kind = #ptr{type = {struct, 15020482145304562784}, idx = 3, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = targetsFile, kind = #data{type = bool, align = 119, default = <<0:1>>}},
				  #field{name = targetsConst, kind = #data{type = bool, align = 118, default = <<0:1>>}},
				  #field{name = targetsEnum, kind = #data{type = bool, align = 117, default = <<0:1>>}},
				  #field{name = targetsEnumerant, kind = #data{type = bool, align = 116, default = <<0:1>>}},
				  #field{name = targetsStruct, kind = #data{type = bool, align = 115, default = <<0:1>>}},
				  #field{name = targetsField, kind = #data{type = bool, align = 114, default = <<0:1>>}},
				  #field{name = targetsUnion, kind = #data{type = bool, align = 113, default = <<0:1>>}},
				  #field{name = targetsGroup, kind = #data{type = bool, align = 112, default = <<0:1>>}},
				  #field{name = targetsInterface, kind = #data{type = bool, align = 127, default = <<0:1>>}},
				  #field{name = targetsMethod, kind = #data{type = bool, align = 126, default = <<0:1>>}},
				  #field{name = targetsParam, kind = #data{type = bool, align = 125, default = <<0:1>>}},
				  #field{name = targetsAnnotation, kind = #data{type = bool, align = 124, default = <<0:1>>}}]}}.

'12793219851699983392'() ->
    #schema_node{module = schema_capnp, name = ['Node', const], id = 12793219851699983392,
		 scope = 16610026722781537303, src = <<"schema.capnp:Node.const">>,
		 kind =
		     #struct{dsize = 5, psize = 5, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = type,
					 kind = #ptr{type = {struct, 15020482145304562784}, idx = 3, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = value,
					 kind =
					     #ptr{type = {struct, 14853958794117909659}, idx = 4, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'16728431493453586831'() ->
    #schema_node{module = schema_capnp, name = ['Node', interface], id = 16728431493453586831,
		 scope = 16610026722781537303, src = <<"schema.capnp:Node.interface">>,
		 kind =
		     #struct{dsize = 5, psize = 5, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = methods,
					 kind =
					     #ptr{type = {list, {struct, 10736806783679155584}}, idx = 3, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}},
				  #field{name = extends,
					 kind = #ptr{type = {list, uint64}, idx = 4, default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'13063450714778629528'() ->
    #schema_node{module = schema_capnp, name = ['Node', enum], id = 13063450714778629528,
		 scope = 16610026722781537303, src = <<"schema.capnp:Node.enum">>,
		 kind =
		     #struct{dsize = 5, psize = 5, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = enumerants,
					 kind =
					     #ptr{type = {list, {struct, 10919677598968879693}}, idx = 3,
						  default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.

'11430331134483579957'() ->
    #schema_node{module = schema_capnp, name = ['Node', struct], id = 11430331134483579957,
		 scope = 16610026722781537303, src = <<"schema.capnp:Node.struct">>,
		 kind =
		     #struct{dsize = 5, psize = 5, esize = inlineComposite, union_field = none,
			     fields =
				 [#field{name = dataWordCount, kind = #data{type = uint16, align = 112, default = <<0, 0>>}},
				  #field{name = pointerCount, kind = #data{type = uint16, align = 192, default = <<0, 0>>}},
				  #field{name = preferredListEncoding,
					 kind = #data{type = {enum, 15102134695616452902}, align = 208, default = <<0, 0>>}},
				  #field{name = isGroup, kind = #data{type = bool, align = 231, default = <<0:1>>}},
				  #field{name = discriminantCount, kind = #data{type = uint16, align = 240, default = <<0, 0>>}},
				  #field{name = discriminantOffset,
					 kind = #data{type = uint32, align = 256, default = <<0, 0, 0, 0>>}},
				  #field{name = fields,
					 kind =
					     #ptr{type = {list, {struct, 11145653318641710175}}, idx = 3,
						  default = <<0, 0, 0, 0, 0, 0, 0, 0>>}}]}}.