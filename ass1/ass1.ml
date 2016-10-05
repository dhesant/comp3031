(* COMP3031 Assignment 1 *)
(* Dhesant Nakka *)
(* 20146587 *)

(* Define custom datatypes *)
datatype adj = V of int * int list;
datatype graph = G of adj list;

(* Show full nested data *)
Control.Print.printDepth := 100;

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

(* Question 4 *)
fun get_max_length (G []) = 0
  | get_max_length (G (V(i,v)::nil)) = length(v)
  | get_max_length (G (V(i,v)::V(j,w)::tail)) =  if (length(v) > length(w))
						 then
						     get_max_length(G (V(i,v)::tail))
						 else
						     get_max_length(G (V(j,w)::tail));


fun find_max (G []) = [] 
  | find_max (G v) = let val len = get_max_length(G v)
		     in
			 let fun find_max_helper (len, G []) = []
			       | find_max_helper (len, G (V(i,v)::tail)) =
				 if (length(v) = len)
				 then i::find_max_helper(len, G (tail))
				 else find_max_helper(len, G (tail));
			 in find_max_helper(len, G v)
			 end
		     end;
			    
(* Question 5 *)
fun insert (V(i,[]), V(v)) = V(v)
  | insert (V(v,head::tail), V(j,w)) =
    if (head = j)
    then V(j,w@v::nil)
    else insert(V(v,tail),V(j,w));

fun insert_adj (V(v), G(g)) = G(map (fn x => insert(V(v),x)) g@V(v)::nil);


