note
	description: "[
			Object helper that allows you to access the C array which stores the data in a vector.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	R_REAL

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

feature -- Access

	at (i: INTEGER): REAL
			-- Entry at index `i'
		do
			Result := c_at (item, i)
		end

feature -- Change Element

	put (a_val: REAL; i: INTEGER)
			-- `i'-th entry, by `v'.
		do
			c_put (item, i, a_val)
		end

	fill_with (a: ITERABLE [REAL])
			-- Set items with `a'.
		local
			i: INTEGER
		do
			across a as ic from i := 0 loop
				put (ic.item, i)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	sizeof_external: INTEGER
		external
			"C inline use <Rinternals.h>"
		alias
			"sizeof(double *)"
		end

	 c_at (arg: POINTER; i: INTEGER): REAL
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return *(double *) $arg + $i;
			]"
		end

	 c_put (arg: POINTER; i: INTEGER; a_val: REAL)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				double val = (double) $a_val;	
				((double *)$arg) [$i] = val;
			]"
		end

end
