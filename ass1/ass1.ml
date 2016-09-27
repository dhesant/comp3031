(* Dhesant Nakka
 * 20146587 *)

(* Define custom datatypes *)
datatype adj = V of int * int list;
datatype graph = G of adj list;

(* Show full nested data *)
Control.Print.printDepth := 100;


val n = G [];
val p = G [V(0, [1]), V(1, [0])];
val q = G [V(0, [1]), V(1, [0]), V(2, [])];
val r = G [V (0,[1,2,3]),V (1,[0,2]),V (2,[0,1]),V (3,[0])];


(* Question 1 *)
fun get_edges (x, G []) = [] 
  | get_edges (x, G ( V(i,[])::tail)) = get_edges(x, G (tail))
  | get_edges (x, G ( V(i,(h::t))::tail)) = [x];

