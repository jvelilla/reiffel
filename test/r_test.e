note
	description: "System's root class"
	info: "Initial version automatically generated"

class
	R_TEST

create
	make

feature -- Initialization

	make

		do
			test_version
--			test_initialize_r
			test_call_r_from_eiffel
		end

	test_initialize_r
		local
			l_r: R_EXTERNALS
			args: ARRAYED_LIST [STRING]
		do
			create l_r
			l_r.init_embedded_r_default
			l_r.end_embedded_r
		end

	test_version
		local
			rv: R_VERSION
		do
			create rv
			print ("%NR version: " + rv.R_version.out)
			print ("%NR nick:    " + rv.R_nick)
			print ("%NR major:   " + rv.R_major)
			print ("%NR minor:   " + rv.R_minor)
			print ("%NR year:    " + rv.R_year)
			print ("%NR month:   " + rv.R_month)
			print ("%NR day:     " + rv.R_day)
			io.put_new_line
		end

	test_call_r_from_eiffel
		local
			a: ARRAY [INTEGER]
			e2, arg: R_SEXP
			add1_call: R_SEXP
			ptr: POINTER
			e: TYPED_POINTER [INTEGER]
			li: R_INTEGER
			lr: R_REAL
		do
			r.init_embedded_r_default
				-- Load the R function definition.
			r_source ("foo.R")

				-- Create an Eiffel Array and copy to R
			a := {ARRAY [INTEGER]}<< 1, 2, 3, 4, 5 >>
			arg := r.alloc_vector ({R_INTERNALS_CONSTANTS}.intsxp, 5)
			li := r.integer (arg)
			li.fill_with (a)

				-- Call the function
				-- Setup a call to the R function
			add1_call := r.protect(r.lang2(r.install("add1"), arg));

					-- Execute the function
			e2 := r.try_eval(add1_call, r.global_env, e)

			print("%NR returned: ");
			lr := r.real (e2)
			across 0 |..| 4 as i loop
				print ( lr.at (i.item))
				print (" ")
			end
			r.unprotect (2)
			r.end_embedded_r
		end

	r_source (a_name: STRING)
			-- Loads R function definitions
			-- r_source (¨test.R¨)
		local
			e1, ge, l_result: R_SEXP
			e: TYPED_POINTER [INTEGER]
		do
			e1 := r.protect (r.lang2 (r.install ("source"),r.mk_string(a_name)))
			ge := r.global_env
			l_result := r.try_eval (e1, ge, e)
			r.unprotect (1)
		end

	r: R_EXTERNALS
		once
			create Result
		end

end -- class R_TEST
