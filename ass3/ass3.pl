% Problem 1

dot(L1,L2,X) :-
	length(L1, Length1),
	length(L2, Length2),
	Length1 =\= 0,
	Length1 =:= Length2,
	dotHelper(L1,L2,0,X).

dotHelper(L1,L2,Prev,X) :-
	[Head1|Tail1] = L1,
	[Head2|Tail2] = L2,
	Current is Prev + (Head1 * Head2),
	dotHelper(Tail1,Tail2,Current,X).

dotHelper([],[],Prev,X) :-
	X = Prev.
