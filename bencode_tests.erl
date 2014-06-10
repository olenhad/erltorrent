-module(bencode_tests).
-include_lib("eunit/include/eunit.hrl").

decode_str_test() ->
    ?assertMatch({ok, <<"cat">>}, bencode:decode(<<"3:cat">>)),
    ?assertMatch({error,_}, bencode:decode(<<"3:ca">>)),
    ?assertMatch({error,_},bencode:decode(<<"3:cats">>)).

decode_int_test() ->
    ?assertMatch({ok,58}, bencode:decode(<<"i58e">>)),
    ?assertMatch({ok,0}, bencode:decode(<<"i0e">>)),
    ?assertMatch({ok,-123}, bencode:decode(<<"i-123e">>)),
    ?assertMatch({ok,(1 bsl 63)}, bencode:decode(<<"i9223372036854775808e">>)).

decode_list_test() ->
    ?assertMatch({ok, {list, [<<"eggs">>, 45]}},
                 bencode:decode(<<"l4:eggsi45ee">>)),
    ?assertMatch({ok, {list, []}}, bencode:decode(<<"le">>)).

decode_dict_test() ->
    {ok, {dict, D}} = bencode:decode(<<"d3:cow3:moo4:spam4:eggse">>),
    ?assertEqual(dict:from_list([{<<"cow">>, <<"moo">>},
                                 {<<"spam">>, <<"eggs">>}]),D).
