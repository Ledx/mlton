(* Copyright (C) 2004 Henry Cejtin, Matthew Fluet, Suresh
 *    Jagannathan, and Stephen Weeks.
 *
 * MLton is released under the GNU General Public License (GPL).
 * Please see the file MLton-LICENSE for license information.
 *)

functor PointerTycon (S: POINTER_TYCON_STRUCTS): POINTER_TYCON =
struct

open S

type int = Int.t
   
datatype t = T of {index: int ref}

local
   fun make f (T r) = f r
in
   val index = ! o (make #index)
end

local
   val c = Counter.new 0
in
   fun new () = T {index = ref (Counter.next c)}
end

fun setIndex (T {index = r}, i) = r := i
   
fun fromIndex i = T {index = ref i}
   
fun compare (p, p') = Int.compare (index p, index p')

fun equals (pt, pt') = index pt = index pt'

val op <= = fn (pt, pt') => index pt <= index pt'

fun toString (pt: t): string =
   concat ["pt_", Int.toString (index pt)]

val layout = Layout.str o toString

val stack = new ()
val word8Vector = new ()
val thread = new ()
val weakGone = new ()
val wordVector = new ()

end