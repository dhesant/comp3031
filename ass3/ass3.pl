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


/* Problem 3 */

/* The database of adj facts */
adj([a, [b,c,d]]).
adj([b, [d,e]]).
adj([c, []]).
adj([e, [a]]).
adj([d, [b]]).

/* Problem 4 */
degree(V, D) :-
	adj([V, AdjV]),
	length(AdjV, D).

/* Problem 5 */
edge(V1, V2) :-
	adj([V1, AdjV1]),
	member(V2, AdjV1).