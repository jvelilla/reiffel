note
	description: "[
			At the C-level, all R objects are stored in a common datatype, the SEXP, or S-expression. 
			All R objects are S-expressions so every C function that you create must return a SEXP as output and take SEXPs as inputs. 
			(Technically, this is a pointer to a structure with typedef SEXPREC.) A SEXP is a variant type, with subtypes for all R’s data structures.
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	R_SEXP

inherit

	MEMORY_STRUCTURE


create

	make,
	make_by_pointer

feature -- Measurement

	structure_size: INTEGER
		do
			Result := sizeof_external
		end


feature {NONE} -- Implementation

	sizeof_external: INTEGER
		external
			"C inline use <Rinternals.h>"
		alias
			"sizeof(struct SEXPREC *)"
		end


end
