-module(bencode).
-export([decode/1]).

% TODO error handling

decode(Data) ->
    try dec(Data) of
        {Res,<<"">>} ->
            {ok, Res};
        {Res, _} ->
            {error, {Res, "Error in input. Parsing fails towards the end of the string"}}
    catch
         error:Err ->
            {error, Err}
    end.

dec(<<$l, Tail/binary>>) ->
    dec_list(Tail,[]);
dec(<<$d, Tail/binary>>) ->
    dec_dict(Tail, dict:new());
dec(<<$i, Tail/binary>>) ->
    dec_int(Tail,[]);
dec(Data) ->
    dec_string(Data,[]).



dec_string(<<$:, Tail/binary>>, Acc) ->
    Size = list_to_integer(lists:reverse(Acc)),
    <<Str:Size/binary, Rest/binary>> = Tail,
    {Str, Rest};
dec_string(<<X, Tail/binary>>, Acc) ->
    dec_string(Tail, [X | Acc]).


dec_int(<<$e, Tail/binary>>, Acc) ->
    {list_to_integer(lists:reverse(Acc)), Tail};
dec_int(<<X, Tail/binary>>, Acc) ->
    dec_int(Tail, [X|Acc]).


dec_list(<<$e, Tail/binary>>, Acc) ->
    {{list, lists:reverse(Acc)}, Tail};
dec_list(Data, Acc) ->
    {Decoded, Rest} = dec(Data),
    dec_list(Rest, [Decoded|Acc]).

dec_dict(<<$e, Tail/binary>>, Acc) ->
    {{dict, Acc}, Tail};
dec_dict(Data, Acc) ->
    {Key, Rest1} = dec(Data),
    {Val, Rest2} = dec(Rest1),
    dec_dict(Rest2, dict:store(Key,Val, Acc)).
