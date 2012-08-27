%%% BEGIN pibfi_stripper.erl %%%
%%%
%%% pibfi - Platonic Ideal Brainf*ck Interpreter
%%% Copyright (c)2003 Cat's Eye Technologies.  All rights reserved.
%%%
%%% Redistribution and use in source and binary forms, with or without
%%% modification, are permitted provided that the following conditions
%%% are met:
%%%
%%%   Redistributions of source code must retain the above copyright
%%%   notice, this list of conditions and the following disclaimer.
%%%
%%%   Redistributions in binary form must reproduce the above copyright
%%%   notice, this list of conditions and the following disclaimer in
%%%   the documentation and/or other materials provided with the
%%%   distribution.
%%%
%%%   Neither the name of Cat's Eye Technologies nor the names of its
%%%   contributors may be used to endorse or promote products derived
%%%   from this software without specific prior written permission.
%%%
%%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
%%% CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
%%% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
%%% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%%% DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE
%%% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
%%% OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
%%% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
%%% OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
%%% ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
%%% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
%%% OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%%% POSSIBILITY OF SUCH DAMAGE. 

%% @doc Stripper for <code>pibfi</code>.
%%
%% <p>Takes the internal format as generated by the parser and
%% takes out everything non-essential.</p>
%%
%% @end

-module(pibfi_stripper).
-vsn('2003.0425').
-copyright('Copyright (c)2003 Cat`s Eye Technologies. All rights reserved.').

-export([strip/2]).

%% @spec strip(program(), Exclude::string()) -> program()
%% @doc Strips a Brainf*ck program.

strip(Program, Exclude) ->
  list_to_tuple(lists:reverse(strip(Program, Exclude, 1, []))).

strip(Program, Exclude, Pos, Acc) when Pos > size(Program) ->
  Acc;
strip(Program, Exclude, Pos, Acc) ->
  Element = element(Pos, Program),
  NewElement = case Element of
    {instruction, R0, C0, Core}=I
     when Core == $<; Core == $>; Core == $+; Core == $-;
          Core == $[; Core == $]; Core == $.; Core == $, ->
      strip(Program, Exclude, Pos + 1, [I | Acc]);
    {instruction, R0, C0, Other}=I ->
      case lists:member(Other, Exclude) of
        true ->
          strip(Program, Exclude, Pos + 1, [I | Acc]);
	false ->
          strip(Program, Exclude, Pos + 1, Acc)
      end;
    {while, R0, C0, Block} ->
      strip(Program, Exclude, Pos + 1,
       [{while, R0, C0, strip(Block, Exclude)} | Acc])
  end.

%%% END of pibfi_stripper.erl %%%