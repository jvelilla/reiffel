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
			r.init_embedded_r_default
			test_version
			test_call_r_from_eiffel
			test_parse_eval
			eval_expression
			test_eval_expression_2
			r.end_embedded_r
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
			e: INTEGER
			li: R_INTEGER
			lr: R_REAL
		do
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
			e2 := r.try_eval(add1_call, r.global_env, $e)

			print("%NR returned: ");
			lr := r.real (e2)
			across 0 |..| 4 as i loop
				print ( lr.at (i.item))
				print (" ")
			end
			r.unprotect (1)
			r.end_embedded_r
		end

	r_source (a_name: STRING)
			-- Loads R function definitions
			-- r_source (�test.R�)
		local
			e1, ge, l_result: R_SEXP
			e: INTEGER
		do
			e1 := r.protect (r.lang2 (r.install ("source"),r.mk_string(a_name)))
			ge := r.global_env
			l_result := r.try_eval (e1, ge, $e)
			r.unprotect (1)
		end

	r: R_EXTERNALS
		once
			create Result
		end

	test_parse_eval
		local
			l_result: R_SEXP
		do
			l_result := parse_eval ("cat(%"Hello World%N%")")
			l_result := parse_eval ("log10(100)")
			r.end_embedded_r
		end

feature -- Eval Expression

	eval_expression
		local
			status: INTEGER
			x, expr: R_SEXP
		do
			expr := r.protect (r.parse_vector (r.mk_string ("2 + 2"), 1, $status, r.nil_value))
			if r.type_of (expr) = {R_INTERNALS_CONSTANTS}.exprsxp then
				expr := r.eval (r.vector_elt (expr, 0), r.global_env)
				r.print_value (expr)
			end
			r.unprotect (1)
			r.end_embedded_r
		end

	test_eval_expression_2
		local
			i, status: INTEGER
			tmp, ret, expr: R_SEXP
		do
				-- Create the R expressions "rnorm(10)" with the R API
			expr := r.protect (r.alloc_vector ({R_INTERNALS_CONSTANTS}.langsxp, 2))
			tmp := r.find_fun (r.install ("rnorm"), r.global_env)
			tmp := r.set_car (expr, tmp)
			tmp := r.set_cadr (expr, r.scalar_integer (10))
				-- Call it, and store the result in ret.
			ret := r.protect (r.try_eval (expr, r.global_env, $status))

			print ("%N Exampple 1 %N")
				-- Print out ret

			from
				i := 0
			until
				i = r.length (ret)
			loop
				print (r.real (ret).at (i))
				print (" ")
				i := i + 1
			end
			r.unprotect (2)
			r.end_embedded_r
		end

--    /* Print out ret */
--    printf("EXAMPLE #1 Output: ");
--    for (i=0; i<length(ret); i++){
--        printf("%f ",REAL(ret)[i]);
--    }
--    printf("\n");

--    UNPROTECT(2);


--    /* EXAMPLE 2*/

--    /* Parse and eval the R expression "rnorm(10)" from a string */
--    PROTECT(tmp = mkString("rnorm(10)"));
--    PROTECT(e = R_ParseVector(tmp, -1, &status, R_NilValue));
--    PROTECT(ret = R_tryEval(VECTOR_ELT(e,0), R_GlobalEnv, NULL));

--    /* And print. */
--    printf("EXAMPLE #2 Output: ");
--    for (i=0; i<length(ret); i++){
--        printf("%f ",REAL(ret)[i]);
--    }
--    printf("\n");

--    UNPROTECT(3);
--    Rf_endEmbeddedR(0);

feature -- Parse Eval

	parse_eval (a_string: STRING): R_SEXP
			-- Parsing R code from Eiffel.
		local
			status: R_PARSE_STATUS_ENUM
			cmd_sexp: R_SEXP
			cmd_expr: R_SEXP
			i: INTEGER
			lstatus,error: INTEGER
			l_string: STRING
			exit: BOOLEAN
		do
			io.put_new_line
			create Result.make
			cmd_expr := r.nil_value
			create l_string.make_from_string (a_string)

			cmd_sexp := r.protect (r.alloc_vector ({R_INTERNALS_CONSTANTS}.strsxp, 1))
			r.set_string_etl (cmd_sexp, 0, r.mk_char (l_string))
			r.print_value (cmd_sexp)

			cmd_expr := r.protect (r.parse_vector (cmd_sexp, -1, $lstatus, r.nil_value))

			if lstatus.to_integer_32 = {R_PARSE_STATUS_ENUM}.PARSE_OK then
				from
					i := 0
				until
					i = r.length (cmd_expr)
				loop
					Result := r.try_eval (r.vector_elt (cmd_expr, i), r.global_env, $error)
					if error.to_integer_32 /=0 then
						print("%N Error evaluation R code ( " + a_string + " )")
						r.unprotect (2)
						exit := True
					else
						r.print_value (Result)
					end
					i := i + 1
				end
			elseif lstatus.to_integer_32 = {R_PARSE_STATUS_ENUM}.PARSE_INCOMPLETE then
				print ("%NParse Incomplete, need to read another line")
			elseif lstatus.to_integer_32 = {R_PARSE_STATUS_ENUM}.PARSE_NULL then
				print ("%NParse Null")
				r.unprotect (2)
				exit := True
			elseif lstatus.to_integer_32 = {R_PARSE_STATUS_ENUM}.PARSE_ERROR then
				print ("%NParse Error: " + a_string )
				r.unprotect (2)
				exit := True
			elseif lstatus.to_integer_32 = {R_PARSE_STATUS_ENUM}.PARSE_EOF then
				print ("%NParse EOF")
			else
				print ("%NParse Default")
				r.unprotect (2)
				exit := True
			end
			if not exit then
				r.unprotect (2)
			end
		end


end -- class R_TEST
