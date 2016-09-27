(* COMP3031 Assignment 1 *)
(* Dhesant Nakka *)
(* 20146587 *)

(* Define custom datatypes *)
datatype adj = V of int * int list;
datatype graph = G of adj list;

(* Show full nested data *)
Control.Print.printDepth := 100;

(* Testing Variables *)
val n = G [];
val p = G [V(0, [1]), V(1, [0])];
val q = G [V(0, [1]), V(1, [0]), V(2, [])];
val r = G [V (0,[1,2,3]),V (1,[0,2]),V (2,[0,1]),V (3,[0])];


(* Question 1 *)
fun get_edges (x, G []) = [] 
  | get_edges (x, G ( V(i,[])::tail)) = if (i = x)
					then []
					else get_edges(x, G (tail))
  | get_edges (x, G ( V(i,(h::t))::tail)) = if (i = x)
					    then  (x,h)::get_edges(x, G ( V(i,t)::nil))
					    else get_edges(x, G (tail));

(* Question 2 *)
fun search ((v1,v2), G (v) ) = let val x = get_edges(v1, G (v))
			       in
				   let fun check (a,b,[]) = false 
					 | check (a,b,head::tail) =
					   if (head = (a,b))
					   then true
					   else check(a,b,tail);
				   in check (v1, v2, x)
				   end
			       end;
				   
(* Question 3 *)
fun count_edges (G []) = 0
  | count_edges (G (V(i,v)::tail)) = let val x = get_edges(i, G (V(i,v)::nil))
				    in
					let fun check ([]) = 0
					      | check ((x,y)::tail) =
						if (x < y)
						then 1 + check(tail)
						else check(tail);
					in check(x) + count_edges(G(tail))
					end
				    end;
					
