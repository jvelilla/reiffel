note
	description: "R externals interface"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=R API", "src=https://cran.r-project.org/doc/manuals/r-release/R-exts.html#The-R-API", "protocol=uri"

deferred class
	R_EXTERNALS_I

feature -- Status Report

	is_api_available: BOOLEAN
			-- Is R API available?
		deferred
		end

feature -- Intialization

	init_embedded_r_default
			-- Intialize the embedded R environment in silent mode.
		deferred
		end

feature  -- shutdown

	end_embedded_r
			-- Release R environment
		deferred
		end

feature -- Access: Rembedded

	set_start_time
		deferred
		end

feature -- Access: Rinternals Function.

	install (a_str: STRING): R_SEXP
		deferred
		end

	lang2 (a_sexp1, a_sexp2: R_SEXP): R_SEXP
		deferred
		end

	mk_string (a_str: STRING): R_SEXP
		deferred
		end

	alloc_Vector (a_type: INTEGER_64; a_len: INTEGER_64): R_SEXP
		deferred
		end

	try_eval (a_sexp1, a_sexp2: R_SEXP; a_error: TYPED_POINTER[INTEGER]): R_SEXP
		deferred
		end

	integer (a_sexp: R_SEXP): R_INTEGER
		deferred
		end

	real (a_sexp: R_SEXP): R_REAL
		deferred
		end

	length (a_sexp: R_SEXP): INTEGER
			--  length of a vector.
		deferred
		end


feature -- Access: Rinternals - Evaluation Environment

	global_env: R_SEXP
			-- The "global" environment
		deferred
		end

feature -- Pointer Protection and Unprotection: Rinternals

	protect (a_sexp: R_SEXP): R_SEXP
			-- Put the `a_sepx` R object to the short-term
			-- stack of objects protected from garbase collection
		deferred
		end

	unprotect (n: INTEGER)
			-- Release the `n` objects last added to the protection stack.
		deferred
		end
end
