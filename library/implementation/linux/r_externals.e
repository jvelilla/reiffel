note
	description: "Summary description for {R_EXTERNALS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	R_EXTERNALS

inherit

	R_EXTERNALS_I


feature -- Status Report

	is_api_available: BOOLEAN
			-- Is R API available?
		do
			Result := True
		end

feature -- Intialization

	init_embedded_r_default
			-- Intialize the embedded R environment in silent mode.
		local
			r: INTEGER
			a: ARRAY [STRING]
		do
			r := Rf_initEmbeddedR_default
		end

feature  -- shutdown

	end_embedded_r
			-- Release R environment
		do
			Rf_endEmbeddedR
		end

feature -- Access

	set_start_time
		do
			R_setStartTime
		end

feature -- Access: Rinternals Functions

	install (a_str: STRING): R_SEXP
		local
			c_str: C_STRING
			l_ptr: POINTER
		do
			create Result.make
			create c_str.make (a_str)
			l_ptr := Rf_install (c_str.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	lang2 (a_sexp1, a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := rf_lang2 (a_sexp1.item, a_sexp2.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	mk_string (a_str: STRING): R_SEXP
		local
			c_str: C_STRING
			l_ptr: POINTER
		do
			create Result.make
			create c_str.make (a_str)
			l_ptr := Rf_mkString (c_str.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	alloc_vector (a_type: INTEGER_64; a_len: INTEGER_64): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_allocVector (a_type, a_len)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	try_eval (a_sexp1, a_sexp2: R_SEXP; a_error: TYPED_POINTER[INTEGER]): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_tryEval (a_sexp1.item, a_sexp2.item, a_error)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	integer (a_sexp: R_SEXP): R_INTEGER
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_integer (a_sexp.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	real (a_sexp: R_SEXP): R_REAL
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_real (a_sexp.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	length (a_sexp: R_SEXP): INTEGER
			--  length of a vector.
		do
			Result := Rf_length (a_sexp.item)
		end

feature -- Access: Rinternals - Evaluation Environment

	global_env: R_SEXP
			-- The "global" environment.
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_GlobalEnv
			if  l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

 feature -- Pointer Protection and Unprotection: Rinternals

	protect (a_sexp: R_SEXP): R_SEXP
			-- Put the `a_sepx` R object to the short-term
			-- stack of objects protected from garbase collection
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := rf_protect (a_sexp.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	unprotect (n: INTEGER)
			-- Release the `n` objects last added to the protection stack.
		do
			rf_unprotect (n)
		end

feature {NONE} -- C externals:Rembedded

	Rf_initEmbeddedR_default : INTEGER
			-- Defined as int Rf_initEmbeddedR(int argc, char *argv[]);
		external
			"C inline use <Rembedded.h>"
		alias
			"[
				char *r_argv[] = { "R", "--silent" };
				return Rf_initEmbeddedR (2, r_argv);
			]"
		end

	Rf_endEmbeddedR
			-- Defined as void Rf_endEmbeddedR(int fatal);
		external
			"C inline use <Rembedded.h>"
		alias
			"[
				Rf_endEmbeddedR (0);
			]"
		end


	R_setStartTime
			-- Defined as void R_setStartTime(void);
		external
			"C inline use <Rembedded.h>"
		alias
			"[
				R_setStartTime ();
			]"
		end

feature {NONE} -- C externals:Rinternals

	Rf_install (p: POINTER): POINTER
			-- Defined SEXP Rf_install(const char *)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_install((const char *)$p);
			]"
		end

	Rf_lang2 (a_sexp1, a_sexp2: POINTER): POINTER
			-- Defined SEXP	 Rf_lang2(SEXP, SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_lang2((SEXP)$a_sexp1, (SEXP)$a_sexp2);
			]"
		end

	Rf_mkString (p: POINTER): POINTER
			-- Defined SEXP	 Rf_mkString(const char *);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_mkString((const char *)$p);
			]"
		end

	Rf_protect (p: POINTER): POINTER
			-- Defined SEXP Rf_protect(SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_protect((SEXP)$p);
			]"
		end

	Rf_unprotect (n: INTEGER)
			-- Defined void Rf_unprotect(int);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				Rf_unprotect((int)$n);
			]"
		end

	Rf_allocVector (a_type: INTEGER_64; a_len: INTEGER_64): POINTER
			-- Defined as SEXP     Rf_allocVector(SEXPTYPE, R_xlen_t);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_allocVector((SEXPTYPE)$a_type, (R_xlen_t)$a_len);
			]"
		end

	R_GlobalEnv: POINTER
			-- Defined as SEXP	R_GlobalEnv;	
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				R_GlobalEnv
			]"
		end

	R_tryEval (a_sexp1, a_sexp2: POINTER; a_error: TYPED_POINTER [INTEGER]): POINTER
			-- Defined as SEXP R_tryEval(SEXP, SEXP, int *);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return R_tryEval((SEXP)$a_sexp1, (SEXP)$a_sexp2, (int *)$a_error);
			]"
		end

	R_integer (a_sexp: POINTER): POINTER
			-- Defined as SEXP R_tryEval(SEXP, SEXP, int *);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return ((int *) DATAPTR($a_sexp));
			]"
		end

	R_real (a_sexp: POINTER): POINTER
			-- Defined as REAL(x) ((double *) DATAPTR(x))
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return ((double *) DATAPTR($a_sexp))
			]"
		end

	Rf_length (a_sexp: POINTER): INTEGER
			-- Defined as R_len_t Rf_length(SEXP x)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_length((SEXP)$a_sexp);
			]"
		end
end
