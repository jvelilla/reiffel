note
	description: "[
			Object helper that allows you to access the C array which stores the data in a vector.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	R_INTEGER

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

	at (i: INTEGER): INTEGER
			-- Entry at index `i'
		do
			Result := c_at (item, i)
		end

feature --Change Element

	put (a_val: INTEGER; i: INTEGER)
			-- Replace `i'-th entry, by `v'.
		do
			c_put (item, i, a_val)
		end

	fill_with (a: ITERABLE [INTEGER])
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
			"sizeof(int *)"
		end

	 c_at (arg: POINTER; i: INTEGER): INTEGER
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return *(int *) $arg + $i;
			]"
		end

	 c_put (arg: POINTER; i: INTEGER; a_val: INTEGER)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				int val = (int) $a_val;	
				((int *)$arg) [$i] = val;
			]"
		end

end
