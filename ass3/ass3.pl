/* Problem 1 */

dot(L1,L2,X) :-
	length(L1, Length1),
	length(L2, Length2),
	Length1 =\= 0,		% Ensure L1 has some length
	Length1 =:= Length2,	% Ensure L1 is the same length as L2
	dotHelper(L1,L2,0,X).   % Call dotHelper to recursively calculate the dot product

% Helper function to recursively calculate dot product
dotHelper(L1,L2,Prev,X) :-      
	[Head1|Tail1] = L1,
	[Head2|Tail2] = L2,
	Current is Prev + (Head1 * Head2),
	dotHelper(Tail1,Tail2,Current,X).

dotHelper([],[],Prev,X) :-
	X = Prev.

/* Problem 2 */
enum(_,0,L) :-
	L = [],
	!.

enum(X,N,L) :-
	enumHelper(X,N,[],L).

enumHelper(X,N,L,L3) :-
	length(X,LengthX),
	LengthX < N,
	L3 = L,
	!.

enumHelper(X,N,L,L3) :-
	length(X,LengthX),
	LengthX >= N,
	headN(X,N,SubL),
	append(L,[SubL],NewL),
	[_|T] = X,
	enumHelper(T,N,NewL,L3).

headN(Input,N,Output) :- findall(E, (nth1(I,Input,E), I =< N), Output).

/* The database of adj facts */
adj([a, [b,c,d]]).
adj([b, [d,e]]).
adj([c, []]).
adj([e, [a]]).
adj([d, [b]]).

/* Problem 3 */
vlist(L,N) :-
	vlistHelper(L, [], 0, N).

vlistHelper(L, CurrentL, CurrentN, N) :-
	CurrentN < N,
	adj([V|_]),
	\+ memberchk(V,CurrentL),
	append(CurrentL, [V], NewL),
	NewN is CurrentN + 1,
	vlistHelper(L, NewL, NewN, N),
	!.

vlistHelper(L, CurrentL, CurrentN, N) :-
	CurrentN =:= N,
	L = CurrentL.

/* Problem 4 */
degree(V, D) :-
	nonvar(V),
	adj([V, AdjV]),
	length(AdjV, D),
	!.

degree(V, D) :-
	adj([V, AdjV]),
	length(AdjV, D).

/* Problem 5 */
edge(V1, V2) :-
	nonvar(V1),
	nonvar(V2),
	adj([V1, AdjV1]),
	member(V2, AdjV1),
	!.

edge(V1, V2) :-
	adj([V1, AdjV1]),
	member(V2, AdjV1).

