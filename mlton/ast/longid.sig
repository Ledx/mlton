(* Copyright (C) 1999-2002 Henry Cejtin, Matthew Fluet, Suresh
 *    Jagannathan, and Stephen Weeks.
 * Copyright (C) 1997-1999 NEC Research Institute.
 *
 * MLton is released under the GNU General Public License (GPL).
 * Please see the file MLton-LICENSE for license information.
 *)
signature LONGID_STRUCTS =
   sig
      structure Strid: AST_ID
      structure Id: AST_ID
   end

signature LONGID =
   sig
      include LONGID_STRUCTS
      include T

      datatype node = T of {strids: Strid.t list,
			    id: Id.t}

      include WRAPPED sharing type node' = node
		      sharing type obj = t

      val bogus: t
      val fromString: string * Region.t -> t
      val isLong: t -> bool (* returns true if the list of strids is nonempty *)
      val long: Strid.t list * Id.t -> t
      (* prepend with a path: 
       * prepend (([B, C], x), A) = ([A, B, C], x)
       * prepends (([C, D], x), [A, B]) = ([A, B, C, D], x)
       *)
      val prepend: t * Strid.t -> t
      val prepends: t * Strid.t list -> t
      val short: Id.t -> t
      val split: t -> Strid.t list * Id.t
      val toId: t -> Id.t
      val toString: t -> string
   end
