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

%% @copyright 2013, Andreas Stenius
%% @author Andreas Stenius <kaos@astekk.se>
%% @doc Read/Write/Allocate references.
%%
%% Everything reference.
%% Which is almost everything in Cap'n Proto :p.

-module(ecapnp_ref).
-author("Andreas Stenius <kaos@astekk.se>").

-export([alloc/3, alloc/4, alloc_data/1, alloc_data/2, alloc_list/3,
         copy/1, create_ptr/2, follow_far/1, get/3, get/4, null_ref/1,
         paste/2, ptr/2, read_data/1, read_data/2, read_list/1,
         read_list/2, read_list_refs/3, read_struct_data/3,
         read_struct_data/4, read_struct_ptr/2, read_struct_ptr/3,
         read_text/1, read_text/2, refresh/1, set/2, write_data/3,
         write_list/4, write_struct_data/4, write_struct_ptr/2,
         write_text/3]).

-include("ecapnp.hrl").


%% ===================================================================
%% API functions
%% ===================================================================

%% @doc Allocate data for a reference.
%%
%% The allocated data is left empty.
-spec alloc(segment_id(), integer(), pid()) -> ref().
alloc(SegmentId, Size, #builder{ pid = Pid }=Builder) ->
    {Id, Pos} = ecapnp_data:alloc(SegmentId, Size, Pid),
    #ref{ segment = Id, pos = Pos, data = Builder }.

%% @doc Allocate data for a reference of a specific kind.
%%
%% The reference will be written to the first word of the allocated
%% data, by {@link set/2}.
%%
%% @see set/2
%% @see alloc/3
-spec alloc(ref_kind(), segment_id(), integer(), pid()) -> ref().
alloc(Kind, SegmentId, Size, Builder) ->
    set(Kind, alloc(SegmentId, Size, Builder)).

%% @doc Set reference kind.
%%
%% Updates the reference kind and writes it to the segment data at
%% `Ref.pos'.
%%
%% @see alloc/4
set(Kind, #ref{ data = Data }=Ref) ->
    Ref1 = if is_record(Kind, interface_ref) ->
                  Ref#ref{
                    offset = get_cap_idx(Kind, Data),
                    kind = Kind };
             true ->
                   Ref#ref{ kind=Kind }
          end,
    ok = write(Ref1),
    Ref1.

%% @doc Get reference from segment data.
%%
%% Read segment, and parse it for a reference pointer.
%%
%% Will follow far pointers.
%%
%% @see get/4
-spec get(segment_id(), integer(), pid() | binary()) -> ref().
get(SegmentId, Pos, Data) ->
    get(SegmentId, Pos, Data, true).

-spec get(segment_id(), integer(), pid() | binary(), boolean()) -> ref().
%% @doc Get reference from segment data.
%%
%% Read segment, and parse it for a reference pointer.
%%
%% The resulting reference may be a far pointer, unless `FollowFar' is `true'.
%%
%% @see read_segment/5
%% @see ecapnp_data:get_segment/4
get(SegmentId, Pos, Data, FollowFar) ->
    read_segment(
      SegmentId, Pos,
      read(SegmentId, Pos, 1, Data),
      Data, FollowFar).

-spec refresh(ref()) -> ref().
%% @doc Reread reference from message.
refresh(#ref{ segment=SegmentId, pos=Pos, data=Data }) ->
    get(SegmentId, Pos, Data).

-spec ptr(integer(), ref()) -> ref().
%% @doc Get indexed reference (unintialized).
%%
%% NOTICE: That by 'uninitialized', the returned reference is a null
%% reference, regardless of what data currently is in the segment.
%%
%% That is, for structs, get a reference for pointer `Idx', while for
%% lists, get a reference for the element at `Idx' (either a pointer
%% or a "unpositioned" ref pointing to where a inlineComposite element
%% holds its data).
ptr(Idx, #ref{ segment=SegmentId, pos=Pos, offset=Offset, data=Data,
               kind=#struct_ref{ dsize=DSize, psize=PSize } })
  when Idx >= 0, Idx < PSize ->
    #ref{ segment=SegmentId, data=Data,
          pos=Pos + 1 + Offset + DSize + Idx };
ptr(Idx, #ref{ segment=SegmentId, pos=Pos, offset=Offset, data=Data,
               kind=#list_ref{ size=pointer, count=Count } })
  when Idx >= 0, Idx < Count ->
    #ref{ segment=SegmentId, data=Data,
          pos=Pos + 1 + Offset + Idx };
ptr(Idx, #ref{ segment=SegmentId, pos=Pos, offset=Offset, data=Data,
               kind=#list_ref{ size={inlineComposite, Tag}, count=Count } })
  when Idx >= 0, Idx < Count ->
    #ref{ segment=SegmentId, data=Data, kind=Tag,
          pos=-1, offset=Pos + Offset + 2 +
              (ref_data_size(Tag) * Idx) }.

%% @doc Read from data section of a struct ref.
%%
%% `Align' is number of bits into the data section to read from, and
%% `Len' is number of bits to read.
-spec read_struct_data(integer(), integer(), ref()) -> binary().
read_struct_data(Align, Len, Ref) ->
    read_struct_data(Align, Len, Ref, <<0:Len/integer>>).

%% @doc Read from data section of a struct ref.
%%
%% `Align' is number of bits into the data section to read from, and
%% `Len' is number of bits to read.
-spec read_struct_data(integer(), integer(), ref(), any()) -> binary() | any().
read_struct_data(_, _, #ref{ kind=null }, Default) -> Default;
read_struct_data(FAlign, Len,
                 #ref{ align=DAlign,
                       kind=#struct_ref{ dsize = DSize } }=Ref,
                 Default) ->
    Align = FAlign + DAlign,
    if Align + Len =< DSize * 64 ->
            <<_:Align/bits, Value:Len/bits, _/bits>>
                = read(1 + ((Align + Len - 1) div 64), Ref),
            Value;
       true -> Default
    end.

%% @doc Read a refeference from the pointer section of struct ref.
-spec read_struct_ptr(integer(), ref()) -> ref().
read_struct_ptr(Idx, Ref) -> read_struct_ptr(Idx, Ref, null_ref(Ref)).

%% @doc Read a refeference from the pointer section of struct ref.
-spec read_struct_ptr(integer(), ref(), any()) -> ref() | any().
read_struct_ptr(_, #ref{ kind=null }, Default) -> Default;
read_struct_ptr(Idx, #ref{ segment=SegmentId, pos=Pos,
                           offset=Offset, data=Data,
                           kind=#struct_ref{ dsize=DSize, psize=PSize } },
                Default) ->
    if Idx >= 0 andalso Idx < PSize ->
            get(SegmentId, Pos + 1 + Offset + DSize + Idx, Data);
       true -> Default
    end.

%% @doc Read elements from a list ref.
-spec read_list(ref()) -> [ref()] | [binary()].
read_list(Ref) -> do_read_list(Ref, default, []).

%% @doc Read elements from a list ref.
-spec read_list(ref(), any()) -> [ref()] | [binary()] | any().
read_list(Ref, Default) -> do_read_list(Ref, default, Default).

%% @doc Read elements from a list ref, forcing the result into a list of refs.
read_list_refs(Ref, ElementRefKind, Default) ->
    do_read_list(Ref, ElementRefKind, Default).

%% @doc Read text.
%%
%% NOTICE: The required trailing `NULL' byte is silently dropped when
%% reading the text.
-spec read_text(ref()) -> binary().
read_text(Ref) -> read_text(Ref, <<>>).

%% @doc Read text.
%%
%% NOTICE: The required trailing `NULL' byte is silently dropped when
%% reading the text.
-spec read_text(ref(), any()) -> binary() | any().
read_text(#ref{ kind=#list_ref{ size=8, count=0 } }, _) -> <<>>;
read_text(#ref{ kind=#list_ref{ size=8, count=Count } }=Ref, _) ->
    binary_part(read(1 + ((Count - 2) div 8), Ref), 0, Count - 1);
read_text(#ref{ kind=null }, Default) -> Default.

%% @doc Read data.
-spec read_data(ref()) -> binary().
read_data(Ref) -> read_data(Ref, <<>>).

%% @doc Read data.
-spec read_data(ref(), any()) -> binary() | any().
read_data(#ref{ kind=#list_ref{ size=8, count=0 } }, _) -> <<>>;
read_data(#ref{ kind=#list_ref{ size=8, count=Count } }=Ref, _) ->
    binary_part(read(1 + ((Count - 1) div 8), Ref), 0, Count);
read_data(#ref{ kind=null }, Default) -> Default.

%% @doc Write to struct data section.
-spec write_struct_data(integer(), integer(), binary(), ref()) -> ok.
write_struct_data(FAlign, Len, Value,
                  #ref{ align=DAlign,
                        kind=#struct_ref{ dsize=DSize } }=Ref) ->
    Align = FAlign + DAlign,
    if Align + Len =< DSize * 64 ->
            <<Pre:Align/bits, _:Len/bits, Post/bits>>
                = read(1 + ((Align + Len - 1) div 64), Ref),
            write(<<Pre/bits, Value:Len/bits, Post/bits>>, Ref)
    end.

%% @doc Write pointer reference.
%%
%% `Ptr' must be a pointer from `Ref' (i.e. the pointer is within the
%% data bounds of the reference).
-spec write_struct_ptr(ref(), ref()) -> ok.
write_struct_ptr(Ptr, Ref) ->
    check_ptr(Ptr, Ref),
    write(Ptr).

%% @doc Write text.
%%
%% Allocates data for `Text' and updates the `Ptr' in `Ref' to point
%% to the newly allocated (and updated) data.
%%
%% NOTICE: An additional `NULL' byte is appended to `Text' to stay
%% conformant with Cap'n Proto specifications.
-spec write_text(binary(), ref(), ref()) -> ok.
write_text(Text, Ptr, Ref) ->
    write_data(<<Text/binary, 0>>, Ptr, Ref).

%% @doc Write data.
%%
%% Allocates data for `Data' and updates the `Ptr' in `Ref' to point
%% to the newly allocated (and updated) data.
-spec write_data(binary(), ref(), ref()) -> ok.
write_data(Data, Ptr, Ref) ->
    check_ptr(Ptr, Ref),
    ListRef = #list_ref{ size = 8, count = size(Data) },
    Ptr1 = alloc_data(Ptr#ref{ kind = ListRef }),
    write(Data, Ptr1).

-spec alloc_data(ref()) -> ref().
%% @doc Allocate data for reference.
%%
%% The number of words allocated is deduced from the passed `Ref'erence.
%%
%% Returns an updated reference with the offset field updated to point
%% at the newly allocated data.
alloc_data(Ref) ->
    alloc_data(ref_data_size(Ref), Ref).

-spec alloc_data(word_count(), ref()) -> ref().
%% @doc Allocate data for reference.
alloc_data(Size, #ref{ segment=SegmentId, data=#builder{ pid=Pid } }=Ref) ->
    {Seg, Pos} = ecapnp_data:alloc(SegmentId, Size, Pid),
    Ref1 = if Seg =:= SegmentId ->
                   update_offset(Pos, Ref);
              true ->
                   %% write far ptr
                   ok = write(
                          Ref#ref{
                            offset = Pos,
                            kind = #far_ref{ segment = Seg }
                           }),
                   %% move target ptr (one extra word was allocated to
                   %% hold the landing pad due to far ptr)
                   Ref#ref{ segment = Seg, pos = Pos, offset = 0 }
           end,
    %% write updated ref
    ok = write(Ref1),
    Ref1.


%% @doc Allocate data for list.
%%
%% `Kind' should be a `#list_ref{}' describing the list to
%% allocate; but for `inlineComposite' lists, the `#list_ref.size'
%% field should point to a `#struct_ref{}' describing the list element
%% type, and `#list_ref.count' should still be the number of elements
%% rather than the total word count.
%%
%% @see alloc_data/1
-spec alloc_list(integer(), ref_kind(), ref()) -> ref().
alloc_list(Idx, #list_ref{ size=Size, count=Count }=Kind, Ref) ->
    Ptr = ptr(Idx, Ref),
    #ref{ pos=Pos, offset=Offset }=List =
        alloc_data(Ptr#ref{ kind=Kind }),
    case Size of
        {inlineComposite, Tag} ->
            ok = write(List#ref{ pos=Pos + 1 + Offset,
                                 kind=Tag, offset=Count }),
            List;
        _ ->
            List
    end.

%% @doc Write list element.
-spec write_list(integer(), integer(), binary(), ref()) -> ok.
write_list(Idx, ElementIdx, Value, Ref) when ElementIdx >= 0 ->
    {Ptr, Size} =
        case read_struct_ptr(Idx, Ref, undefined) of
            #ref{ kind=#list_ref{ size=S, count=C } }=P
              when ElementIdx < C -> {P, S}
        end,
    {Align, ElementSize} =
        case Size of
            {inlineComposite, Tag} ->
                L = ref_data_size(Tag),
                {1 + (ElementIdx * L), L * 64};
            pointer ->
                {ElementIdx * 64, 64};
            1 ->
                %% take special care for bitfields, as capnproto wants them in big endian order..!
                {round(8 * ((ElementIdx div 8) +
                                ((7 - (ElementIdx rem 8)) / 8))), 1};
            _ -> {ElementIdx * Size, Size}
        end,
    <<Pre:Align/bits, _:ElementSize/bits, Post/bits>>
        = read(1 + ((Align + ElementSize - 1) div 64), Ptr),
    write(<<Pre/bits, Value:ElementSize/bits, Post/bits>>, Ptr).

%% @doc Resolve a far pointer.
%%
%% Usually this is done automatically when reading ref's.
-spec follow_far(ref()) -> ref().
follow_far(#ref{ offset=Offset, data=Data,
                 kind=#far_ref{ segment=SegmentId, double_far=Double } }) ->
    Pad = get(SegmentId, Offset, Data, false),
    if Double ->
            Tag = get(SegmentId, Offset + 1, Data, false),
            Tag#ref{ segment=(Pad#ref.kind)#far_ref.segment,
                     pos=-1, offset=Pad#ref.offset };
       true -> Pad
    end.

-spec copy(ref()) -> binary().
%% @doc Make a deep copy of a reference.
%%
%% Recursively follows all pointers and copies them as well. So
%% copying a root object will effectively defragment a fragmented
%% message.
copy(Ref) ->
    iolist_to_binary(
      flatten_ref_copy(copy_ref(Ref))).

-spec paste(binary(), ref()) -> ref().
%% @doc Allocate space and write data for reference.
%%
%% All data, both data section and pointers section, and any data that
%% those may refer to (good for saving off a deep copy of another
%% object).
%%
%% Note: `Data' should be whole words (8 bytes). Any fraction of a
%% word will be truncated.
paste(<<DataRef:64/bits, Data/binary>>, Ref) ->
    #ref{ offset=0, kind=Kind } = read_ref(DataRef, Ref),
    if is_record(Kind, struct_ref);
       is_record(Kind, list_ref) ->
            case {(size(Data) + 7) div 8, ref_data_size(Kind)} of
                {0, RefSize} ->
                    alloc_data(RefSize, Ref#ref{ kind = Kind });
                {Size, RefSize} when Size >= RefSize ->
                    Ref1 = alloc_data(Size, Ref#ref{ kind=Kind }),
                    ok = write(<<Data:Size/binary-unit:64>>, Ref1),
                    Ref1
            end;
       Kind == null -> set(Kind, Ref)
    end.

%% @doc Get a null pointer.
%%
%% The up-side with this function in contrast to using a default
%% `#ref{}' record on its own is that the null reference returned by
%% this function knows about the schema and segment data of the
%% message for which it was based.
-spec null_ref(ref()) -> ref().
null_ref(#ref{ data=Data }) -> #ref{ pos=-1, data=Data }.


%% ===================================================================
%% internal functions
%% ===================================================================

%% ref_size() -> {DSize, PSize}
ref_size(#ref{ kind=Kind }) -> ref_size(Kind);
ref_size(null) -> {0, 0};
ref_size(#struct_ref{ dsize=DSize, psize=PSize }) -> {DSize, PSize};
ref_size(#list_ref{ size=0 }) -> {0, 0};
ref_size(#list_ref{ size={inlineComposite, Ref}, count=Count }) ->
    {1, (Count * ref_data_size(Ref))};
ref_size(#list_ref{ count=0 }) -> {0, 0};
ref_size(#list_ref{ size=pointer, count=Count }) -> {0, Count};
ref_size(#list_ref{ size=Bits, count=Count }) ->
    {1 + (((Count * Bits) - 1) div 64), 0}.

ref_data_size(Ref) ->
    {D, P} = ref_size(Ref), D + P.

ptr_type(0, 0) -> null;
ptr_type(Offset, _) ->
    ptr_type(Offset band 3).

ptr_type(0) -> struct;
ptr_type(1) -> list;
ptr_type(2) -> far_ptr;
ptr_type(3) -> interface.

decode_list_element_size(0) -> 0;
decode_list_element_size(1) -> 1;
decode_list_element_size(2) -> 8;
decode_list_element_size(3) -> 16;
decode_list_element_size(4) -> 32;
decode_list_element_size(5) -> 64;
decode_list_element_size(6) -> pointer;
decode_list_element_size(7) -> inlineComposite.

%% element size encoded value
encode_element_size(0) -> 0;
encode_element_size(1) -> 1;
encode_element_size(8) -> 2;
encode_element_size(16) -> 3;
encode_element_size(32) -> 4;
encode_element_size(64) -> 5;
encode_element_size(pointer) -> 6;
encode_element_size({inlineComposite, _}) -> 7.

read(Len, #ref{ segment=SegmentId, pos=Pos, offset=Offset, data=Data }) ->
    read(SegmentId, Pos + Offset + 1, Len, Data).

read(SegmentId, Pos, Len, #builder{ pid = Pid }) ->
    ecapnp_data:get_segment(SegmentId, Pos, Len, Pid);
read(0, Pos, Len, #reader{ data = Seg }) when is_binary(Seg) ->
    binary:part(Seg, Pos * 8, Len * 8);
read(SegmentId, Pos, Len, #reader{ data = Segments }) when is_list(Segments) ->
    Seg = lists:nth(SegmentId + 1, Segments),
    binary:part(Seg, Pos * 8, Len * 8).

write(Bin, Offset, #ref{ segment=SegmentId, pos=Pos, data=#builder{ pid = Pid } }) ->
    ecapnp_data:update_segment({SegmentId, Pos + Offset}, Bin, Pid);
write(_, _, _) -> {error, read_only}.

write(Bin, #ref{ offset=Offset }=Ref) ->
    write(Bin, Offset + 1, Ref).

write(#ref{ pos=-1 }) -> ok;
write(#ref{ offset=Offset }=Ref) ->
    write(create_ptr(Offset, Ref), 0, Ref).

check_ptr(#ref{ segment=SegmentId, pos=Ptr, data=Data },
          #ref{ segment=SegmentId, pos=Pos, data=Data, offset=Offset,
                kind=Kind }) ->
    {DSize, PSize} = ref_size(Kind),
    Start = Pos + Offset + 1 + DSize,
    if Ptr >= Start,
       Ptr < (Start + PSize) ->
            ok
    end.

update_offset(Target, #ref{ pos=Pos }=Ref) ->
    Ref#ref{ offset=Target - Pos - 1 }.

read_segment(SegmentId, Pos, Segment, Data, FollowFar)
  when size(Segment) == 8 ->
    Ref = read_ref(Segment, #ref{ segment=SegmentId, pos=Pos, data=Data }),
    if FollowFar, is_record(Ref#ref.kind, far_ref) -> follow_far(Ref);
       true -> Ref
    end;
%% list data
read_segment(SegmentId, _, _, Data, _) ->
    #ref{ segment=SegmentId, pos=-1, data=Data }.

read_ref(<<OffsetAndKind:32/integer-signed-little,
           Size:32/integer-little>>, Ref) ->
    case ptr_type(OffsetAndKind, Size) of
        null -> Ref#ref{ kind = null };
        struct ->
            Ref#ref{ offset = OffsetAndKind bsr 2,
                     kind = #struct_ref{
                               dsize=Size band 16#ffff,
                               psize=Size bsr 16 }};
        list ->
            read_list_ref(
              decode_list_element_size(Size band 7),
              Size bsr 3,
              Ref#ref{ offset = OffsetAndKind bsr 2 });
        far_ptr ->
            Ref#ref{ offset = OffsetAndKind bsr 3,
                     kind = #far_ref{
                               segment=Size,
                               double_far=OffsetAndKind band 4 > 0
                              }};
        interface ->
            Ref#ref{ offset = Size, %% CapTable index
                     kind = get_cap(Size, Ref#ref.data)
                   }
    end.

read_list_ref(inlineComposite, Size, Ref) ->
    #ref{ offset = Count,
          kind = Tag } = read_ref(read(1, Ref), Ref),
    %% sanity check data
    Size = Count * ref_data_size(Tag),
    %% set ref kind and offset
    Ref#ref{ kind = #list_ref{
                       size = {inlineComposite, Tag},
                       count = Count
                      } };
read_list_ref(Size, Count, Ref) ->
    Ref#ref{ kind = #list_ref{
                       size = Size,
                       count = Count }}.

do_read_list(#ref{ kind=#list_ref{ count=0 } }, _RefKind, _Default) -> [];
do_read_list(#ref{ kind=null }, _RefKind, Default) -> Default;
do_read_list(#ref{ segment=SegmentId, pos=Pos, offset=Offset, data=Data,
                   kind=#list_ref{ size=Size, count=Count }=Kind }=Ref,
             ElementRefKind, _Default) ->
    TagOffset = Pos + 1 + Offset,
    case {Size, ElementRefKind} of
        {{inlineComposite, Tag}, _} ->
            ElementRef = Ref#ref{ kind=Tag, pos=-1 },
            ElementSize = ref_data_size(Tag),
            [ElementRef#ref{ offset=O }
             || O <- lists:seq(TagOffset + 1,
                               TagOffset + (Count * ElementSize),
                               ElementSize)];
        {pointer, _} ->
            List = read(SegmentId, TagOffset, Count, Data),
            [read_segment(SegmentId, TagOffset + I,
                          binary_part(List, I*8, 8),
                          Data, true)
             || I <- lists:seq(0, (Count - 1))];
        {0, default} ->
            lists:duplicate(Count, void);
        {0, _} ->
            lists:duplicate(Count, #ref{ data=Data });
        {_, default} when is_integer(Size) ->
            ListSize = ref_data_size(Kind),
            ListData = read(SegmentId, TagOffset, ListSize, Data),
            read_list_elements(Size, ListData, Count, []);
        {_, K} when is_integer(Size) ->
            ElementRef = Ref#ref{ kind = K, pos=-1 },
            StartOffset = TagOffset * (64 div Size),
            [begin
                 Off = O * Size,
                 ElementRef#ref{ offset=Off div 64, align=Off rem 64 }
             end || O <- lists:seq(StartOffset, StartOffset + (Count - 1))]
    end.

read_list_elements(_, _, 0, Acc) -> lists:reverse(Acc);
read_list_elements(1, <<Byte:1/bytes, Rest/binary>>, Count, Acc) ->
    read_list_element_bits(Byte, 7, Count, Rest, Acc);
read_list_elements(Size, List, Count, Acc) ->
    <<Elem:Size/bits, Rest/bits>> = List,
    read_list_elements(Size, Rest, Count - 1, [Elem|Acc]).

%% contrived routine to read bits off from a bit stream that is hard
%% coded big endian.. gnnggn!
read_list_element_bits(_, _, 0, _, Acc) -> lists:reverse(Acc);
read_list_element_bits(_, -1, Count, Rest, Acc) ->
    read_list_elements(1, Rest, Count, Acc);
read_list_element_bits(Bits, Left, Count, Rest, Acc) ->
    <<Next:Left/bits, Bit:1/bits>> = Bits,
    read_list_element_bits(Next, Left - 1, Count - 1, Rest, [Bit|Acc]).

copy_ref(#ref{ kind=null }=Ref) -> {Ref, 0, []};
copy_ref(#ref{ kind=#struct_ref{ dsize=DSize, psize=PSize } }=Ref) ->
    StructData = read_struct_data(0, DSize * 64, Ref),
    StructPtrs = [copy_ref(read_struct_ptr(Idx, Ref))
                  || Idx <- lists:seq(0, PSize - 1)],
    Size = if Ref#ref.pos >= 0 ->
                   DSize + PSize;
              true -> 0
           end,
    {Ref, Size, [StructData|StructPtrs]};
copy_ref(#ref{ kind=#list_ref{ size=ElementSize, count=Count } }=Ref) ->
    Size = ref_data_size(Ref),
    case ElementSize of
        {inlineComposite, Tag} ->
            {Ref, Size, [create_ptr(Count, Tag)
                         |[copy_ref(Elem) || Elem <- read_list(Ref)]
                        ]};
        pointer ->
            {Ref, Size, [copy_ref(Elem) || Elem <- read_list(Ref)]};
        _ ->
            {Ref, Size, [read(Size, Ref)]}
    end.

flatten_ref_copy({Ref, Len, Copy}) ->
    [create_ptr(0, Ref), flatten_copy(Copy, Len - 1)].

flatten_copy(Copy, Offset) ->
    case lists:mapfoldl(
           fun(Bin, {RefData, Pad}) when is_binary(Bin) ->
                   {Bin, {RefData, Pad - (size(Bin) div 8)}};
              ({Ref, Len, Data}, {RefData, Pad}) ->
                   Ptr = create_ptr(Pad, Ref),
                   {Ptr, {[Data|RefData], Pad - (size(Ptr) div 8) + Len}}
           end,
           {[], Offset}, Copy) of
        {Data, {[], _}} -> Data;
        {Data, {RefData, Padding}} ->
            [Data|flatten_copy(
                    lists:flatten(
                      lists:reverse(RefData)),
                    Padding)]
    end.

create_ptr(_Offset, #ref{ pos=-1 }) -> <<>>;
create_ptr(_Offset, null) -> <<0:64/integer>>;
create_ptr(Offset, #ref{ kind=Kind }) -> create_ptr(Offset, Kind);
%% struct ptr
create_ptr(Offset, #struct_ref{ dsize=DSize, psize=PSize }) ->
    Off = (Offset bsl 2) + 0,
    <<Off:32/integer-signed-little,
      DSize:16/integer-little,
      PSize:16/integer-little>>;
%% list ptr
create_ptr(Offset, #list_ref{ size = ElementSize, count=Count }) ->
    Off = (Offset bsl 2) + 1,
    Size =
        case ElementSize of
             {inlineComposite, Tag} ->
                ((Count * ref_data_size(Tag)) bsl 3) + 7;
             _ ->
                 (Count bsl 3) + encode_element_size(ElementSize)
         end,
    <<Off:32/integer-little,
      Size:32/integer-little>>;
%% far ptr
create_ptr(Offset, #far_ref{ segment=Seg, double_far = false }) ->
    Off = (Offset bsl 3) + 2,
    <<Off:32/integer-little, Seg:32/integer-little>>;
%% capability ptr
create_ptr(Idx, #interface_ref{}) ->
    <<3:32/integer-little, Idx:32/integer-little>>.


%% only supported for builders, as readers should not need to lookup cap index
get_cap_idx(Cap, #builder{ pid = Pid }) ->
    ecapnp_data:get_cap_idx(Cap, Pid).

get_cap(Idx, #builder{ pid = Pid }) ->
    ecapnp_data:get_cap(Idx, Pid);
get_cap(Idx, #reader{ caps = CapTable }) when Idx < length(CapTable) ->
    lists:nth(Idx + 1, CapTable);
get_cap(_, _) -> undefined.
