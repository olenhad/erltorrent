-module(utils).
-export([pipe/1]).

pipe([X | Xs]) ->
    Init = X(),
    lists:foldl( fun (F, Acc) -> F(Acc) end,
               Init, Xs).
