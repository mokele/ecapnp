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

-module(ecapnp_ref_tests).
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-include("include/ecapnp.hrl").

-import(ecapnp_test_utils, [data/1]).

get_test() ->
    Data = data([<<4,0,0,0,2,0,3,0>>]),
    ?assertEqual(
       #ref{ segment=0, pos=0, offset=1, data=Data,
             kind=#struct_ref{ dsize=2, psize=3 } },
       ecapnp_ref:get(0, 0, Data)).

read_struct_ptr_test() ->
    Data = ecapnp_data:new(#msg{ data = [<<0,0,0,0, 0,0, 1,0,  41,0,0,0, 23,0,0,0>>] }),
    Ref = ecapnp_ref:get(0, 0, Data),
    ?assertEqual(
       #ref{ segment=0, pos=1, offset=10,
             kind=#list_ref{ size=inlineComposite, count=2 },
             data=Data },
       ecapnp_ref:read_struct_ptr(0, Ref)).

read_struct_data_test() ->
    Data = ecapnp_data:new(#msg{ data = [<<0,0,0,0, 1,0, 0,0,  1,2,3,4, 5,6,7,8>>] }),
    Ref = ecapnp_ref:get(0, 0, Data),
    ?assertEqual(
       <<5, 6>>,
       ecapnp_ref:read_struct_data(32, 16, Ref)).

read_composite_list_test() ->
    Data = ecapnp_data:new(#msg{ data = [<<1,0,0,0, 55,0,0,0,
                                           8,0,0,0, 1,0, 2,0,
                                           0:(6*64)/integer
                                         >>] }),
    Ref = ecapnp_ref:get(0, 0, Data),
    ?assertEqual(
       [#ref{ segment=0, pos=-1, offset=2, data=Data,
              kind=#struct_ref{ dsize=1, psize=2 } },
        #ref{ segment=0, pos=-1, offset=5, data=Data,
              kind=#struct_ref{ dsize=1, psize=2 } }],
       ecapnp_ref:read_list(Ref)).

read_bool_list_test() ->
    Data = ecapnp_data:new(#msg{ data = [<<1,0,0,0, 81,0,0,0,
                                           129,3,0,0, 0,0,0,0
                                         >>] }),
    Ref = ecapnp_ref:get(0, 0, Data),
    ?assertEqual(
       [<<1:1>>, <<0:1>>, <<0:1>>, <<0:1>>,
        <<0:1>>, <<0:1>>, <<0:1>>, <<1:1>>,
        <<1:1>>, <<1:1>>],
       ecapnp_ref:read_list(Ref)).

read_text_test() ->
    Ref = ecapnp_ref:get(
            0, 0, data(
                    [<<1,0,0,0, 106,0,0,0,
                       "Hello World!", 0,
                       0:24/integer>>] %% <- padding to get whole words
                   )),
    ?assertEqual(<<"Hello World!">>,
                 ecapnp_ref:read_text(Ref)).

read_data_test() ->
    Data = <<123456789:64/integer-little,9876544321:64/integer>>,
    Ref = ecapnp_ref:get(
            0, 0, data(
                    [<<1,0,0,0, 130,0,0,0, Data/binary>>]
                   )),
    ?assertEqual(Data, ecapnp_ref:read_data(Ref)).

follow_far_test() ->    
    Data = data([%% segment 0
                 <<2,0,0,0, 1,0,0,0,
                   0,0,0,0, 0,0,1,0>>,
                 %% segment 1
                 <<0,0,0,0, 0,0,0,0>>,
                 %% segment 2
                 <<6,0,0,0, 0,0,0,0>>
                ]),
    Ref = ecapnp_ref:get(0, 0, Data),
    ?assertEqual(
       #ref{ segment=1, pos=0, offset=0, data=Data, kind=null},
       Ref),
    ?assertEqual(
       #ref{ segment=1, pos=-1, offset=0, data=Data,
             kind=#struct_ref{ dsize=0, psize=1 } },
       ecapnp_ref:get(2, 0, Data)).

copy_test() ->
    Bin = <<0,0,0,0, 2,0,2,0,
            1234:32/integer, 5678:32/integer,
            8765:32/integer, 4321:32/integer,
            0:64/integer,
            1,0,0,0, 106,0,0,0,
            "Hello World!", 0,
            0:24/integer
          >>,
    Data = data([Bin]),
    Ref = ecapnp_ref:get(0, 0, Data),
    ?assertEqual(Bin, ecapnp_ref:copy(Ref)).

-endif.