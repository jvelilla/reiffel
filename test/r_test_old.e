note
	description: "System's root class"
	info: "Initial version automatically generated"

class
	R_TEST_OLD

inherit
	R_API
create
	make

feature -- Initialization

	make
			-- Creation procedure.
		local
			e1,e2, e3, add1_call: R_SEXP
			ptr: POINTER
		do
				-- Set up an embedded R environment
			default_create
			init_embedded_r_default

				-- Print R version and dll version
			print (R_version)
			print (" - ")
			print (dll_version)
			io.put_new_line

				-- Simple example
			splines_examples

				-- call R function from Eiffel
			call_r_function_from_eiffel

			end_embedded_r
		end

	splines_examples
		local
			e1, l_result: R_SEXP
			ge: R_SEXP
		do
			e1 := rf_protect (rf_lang2(rf_install ("library"), rf_mkString("splines")))
			ge := r_globalenv
			l_result := r_try_eval (e1, ge)
			rf_unprotect (1)
		end

	call_r_function_from_eiffel
		local
			a: ARRAY [INTEGER]
			e2, arg: R_SEXP
			add1_call: R_SEXP
			ptr: POINTER
		do
				-- Load the R function definition.
			r_source ("foo.R")

				-- Create an Eiffel Array and copy to R
			a := {ARRAY [INTEGER]}<< 1, 2, 3, 4, 5 >>
			arg := rf_allocvector ({R_INTERNALS_CONSTANTS}.intsxp, 5)
			copy_integer_array_to_r (item, arg.item, a.area.base_address, a.count)

				-- Call the function

					-- Setup a call to the R function
			add1_call := rf_protect(rf_lang2(rf_install("add1"), arg));

					-- Execute the function
			e2 := r_try_eval(add1_call, R_GlobalEnv);

			print("%NR returned: ");
			ptr := cR_real (item, e2.item);
			across 0 |..| 4 as i loop
				print (cr_real_value (item, ptr, i.item))
				print (" ")
			end
			rf_unprotect (2)
		end

	r_source (a_name: STRING)
			-- Loads R function definitions
			-- r_source (¨test.R¨)
		local
			e1, ge, l_result: R_SEXP
		do
			e1 :=rf_protect (rf_lang2 (rf_install ("source"),rf_mkString(a_name)))
			ge := r_globalenv
			l_result := r_try_eval (e1, ge)
			rf_unprotect (1)
		end

end -- class R_TEST
