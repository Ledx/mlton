(* Copyright (C) 1999-2002 Henry Cejtin, Matthew Fluet, Suresh
 *    Jagannathan, and Stephen Weeks.
 * Copyright (C) 1997-1999 NEC Research Institute.
 *
 * MLton is released under the GNU General Public License (GPL).
 * Please see the file MLton-LICENSE for license information.
 *)
functor TwoPointLattice (S: TWO_POINT_LATTICE_STRUCTS): TWO_POINT_LATTICE = 
struct

open S

structure Set = DisjointSet
structure List = AppendList
   
datatype t = T of value Set.t
and value =
   Bottom of (unit -> unit) List.t ref  (* If I become Top, then run these. *)
  | Top

fun value (T s) = Set.value s

fun toString e =
   case value e of
      Bottom _ => bottom
    | Top => top

val layout = Layout.str o toString

fun new (): t = T (Set.singleton (Bottom (ref List.empty)))

fun equals (T s, T s') = Set.equals (s, s')

fun addHandler (e, h) =
   case value e of
      Bottom hs => hs := List.cons (h, !hs)
    | Top => h ()

fun isTop s =
   case value s of
      Top => true
    | _ => false

fun isBottom s =
   case value s of
      Bottom _ => true
    | _ => false

fun runHandlers hs = List.foreach (!hs, fn h => h ())

fun makeTop (T s) =
   case Set.value s of
      Top => ()
    | Bottom hs => (Set.setValue (s, Top); runHandlers hs)

fun from <= to =
   if equals (from, to)
      then ()
   else
      case (value from, value to) of
	 (_, Top) => ()
       | (Top, _) => makeTop to
       | (Bottom hs, _) => hs := List.cons (fn () => makeTop to, !hs)

fun == (T s, T s') =
   if Set.equals (s, s')
      then ()
   else
      let val e = Set.value s
	 val e' = Set.value s'
	 val _ = Set.union (s, s')
      in
	 case (e, e') of
	    (Top, Top) => ()
	  | (Bottom hs, Top) => (Set.setValue (s, e'); runHandlers hs)
	  | (Top, Bottom hs) => (Set.setValue (s, e); runHandlers hs)
	  | (Bottom hs, Bottom hs') =>
	       Set.setValue (s, Bottom (ref (List.append (!hs, !hs'))))
      end

end
