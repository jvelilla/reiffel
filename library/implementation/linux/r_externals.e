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

	nil_value: R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_nilValue
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

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

	try_eval (a_sexp1, a_sexp2: R_SEXP; a_error:POINTER): R_SEXP
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

	mk_char (a_str: STRING): R_SEXP
			-- character vector
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_mkChar ((create{C_STRING}.make (a_str)).item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_string_etl (a_x: R_SEXP; a_index: INTEGER; a_v: R_SEXP)
		do
			R_SET_STRING_ELT (a_x.item, a_index, a_v.item)
		end

	eval (a_sexp1, a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_eval (a_sexp1.item, a_sexp2.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	type_of (a_sexp: R_SEXP): INTEGER
		do
			Result := TYPEOF (a_sexp.item)
		end

	find_fund (a_sexp: R_SEXP; a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_findFun (a_sexp.item, a_sexp2.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	scalar_integer (a_integer: INTEGER): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_ScalarInteger(a_integer)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

feature -- Acess: R_ext/Parse

	parse_vector (a_sexp: R_SEXP; a_int: INTEGER; a_status: POINTER; a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := r_parsevector (a_sexp.item, a_int,a_status, a_sexp2.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	vector_elt (a_sexp: R_SEXP; a_index: INTEGER): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_VECTOR_ELT (a_sexp.item, a_index)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	print_value (a_sexp: R_SEXP)
		do
			rf_printvalue (a_sexp.item)
		end


feature -- Access: Rinternals List access functions

	set_car (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr : POINTER
		do
			create Result.make
			l_ptr := setcar (a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cdr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr : POINTER
		do
			create Result.make
			l_ptr := setcdr (a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cadr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr : POINTER
		do
			create Result.make
			l_ptr := setcadr (a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_caddr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr : POINTER
		do
			create Result.make
			l_ptr := setcaddr (a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cadddr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr : POINTER
		do
			create Result.make
			l_ptr := setcadddr (a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cad4r (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr : POINTER
		do
			create Result.make
			l_ptr := setcad4r (a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
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

	R_NilValue : POINTER
			-- Defined LibExtern SEXP	R_NilValue;	    /* The nil object */
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				 R_NilValue
			]"
		end



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

	R_tryEval (a_sexp1, a_sexp2: POINTER; a_error: POINTER): POINTER
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

	Rf_mkChar (a_str: POINTER): POINTER
			-- Defined as SEXP Rf_mkChar(const char* x);	
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_mkChar((const char*) $a_str);
			]"
		end

	R_SET_STRING_ELT (a_x: POINTER; a_i: INTEGER; a_v: POINTER)
			-- Defined as void SET_STRING_ELT(SEXP x, R_xlen_t i, SEXP v);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				SET_STRING_ELT((SEXP) $a_x, (R_xlen_t)$a_i, (SEXP)$a_v);
			]"
		end

	R_VECTOR_ELT (a_sexp: POINTER; a_index: INTEGER): POINTER
			-- Defined as VECTOR_ELT(x,i)	((SEXP *) DATAPTR(x))[i]	
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				//return (SEXP *) $a_sexp + $a_index;
				return VECTOR_ELT($a_sexp, $a_index);
			]"
		end

	Rf_PrintValue (a_sexp: POINTER)
			-- Defined as void Rf_PrintValue(SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				Rf_PrintValue((SEXP)$a_sexp)
			]"
		end


	Rf_eval (a_sexp1: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP Rf_eval(SEXP, SEXP)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_eval((SEXP)$a_sexp1, (SEXP)$a_sexp2);
			]"
		end

	TYPEOF (x: POINTER): INTEGER
			-- Defined as TYPEOF(x)	((x)->sxpinfo.type)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				TYPEOF($x)
			]"
		end

	Rf_findFun (a_sexp: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP Rf_findFun(SEXP, SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_findFun((SEXP)$a_sexp, (SEXP)$a_sexp2);
			]"
		end

	SETCAR (a_sexp: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP SETCAR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return SETCAR((SEXP)$a_sexp, (SEXP)$a_sexp2);
			]"
		end

	SETCDR (a_sexp: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP SETCDR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return SETCDR((SEXP)$a_sexp, (SEXP)$a_sexp2);
			]"
		end

	SETCADR (a_sexp: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP SETCADR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return SETCADR((SEXP)$a_sexp, (SEXP)$a_sexp2);
			]"
		end

	SETCADDR (a_sexp: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP SETCADDR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return SETCADDR((SEXP)$a_sexp, (SEXP)$a_sexp2);
			]"
		end

	SETCADDDR (a_sexp: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP SETCADDDR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return SETCADDDR((SEXP)$a_sexp, (SEXP)$a_sexp2);
			]"
		end

	SETCAD4R (a_sexp: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP SETCAD4R(SEXP e, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return SETCAD4R((SEXP)$a_sexp, (SEXP)$a_sexp2);
			]"
		end

	Rf_ScalarInteger (a_integer: INTEGER): POINTER
			-- Defined as SEXP	 Rf_ScalarInteger(int);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return Rf_ScalarInteger ((int)$a_integer)
			]"
		end

feature {NONE} -- C externals:R_ext/Parse

	R_ParseVector (a_sexp: POINTER; a_int: INTEGER; a_status: POINTER; a_sexp2: POINTER): POINTER
			-- Defined as SEXP R_ParseVector(SEXP, int, ParseStatus *, SEXP);
		external
			"C inline use <reiffel.h>"
		alias
			"[
				return R_ParseVector((SEXP)$a_sexp, $a_int, (ParseStatus *)$a_status, (SEXP)$a_sexp2);
			]"
		end



end
