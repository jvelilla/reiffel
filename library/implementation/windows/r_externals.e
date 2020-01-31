note
	description: "Summary description for {R_EXTERNALS}."
	date: "$Date$"
	revision: "$Revision$"

class
	R_EXTERNALS

inherit

	R_EXTERNALS_I
		undefine
			default_create
		end
	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Defautl creation method.
		local
			retried: BOOLEAN
		do
			if not retried then
				load_r_library
			end
		rescue
			retried := True
			retry
		end

	load_r_library
		local
			r_name: C_STRING
		do
			create r_name.make ("R.dll")
			item := cwin_permanent_load_library (r_name.item)
		end

	cwin_permanent_load_library (dll_name: POINTER): POINTER
			-- Wrapper around LoadLibrary which will automatically
			-- free the dll at the end of system execution.
		external
			"C [macro %"eif_misc.h%"] (char *): EIF_POINTER"
		alias
			"eif_load_dll"
		end

feature -- Status Report

	is_api_available: BOOLEAN
		do
			Result := not item.is_default_pointer
		end

feature -- Access

	item: POINTER
			-- R handle.

feature -- Intialization

	init_embedded_r_default
			-- Intialize the embedded R environment in silent mode.
		local
			r: INTEGER
		do
			r := R_initEmbeddedR_default (item)
		end

	end_embedded_r
			-- Release R environment
		do
			Rf_endEmbeddedR (item)
		end

feature -- Access: Rembedded

	set_start_time
		do
			R_setStartTime (item)
		end

feature -- Access: Rinternals Function.

	dll_version: STRING
			-- only for Windows.
		local
			l_ptr: POINTER
		do
			Result := "Unknown"
			l_ptr := getDLLVersion (item)
			if l_ptr /= default_pointer then
				Result := (create {C_STRING}.make_by_pointer (l_ptr)).string
			end
		end

	nil_value: R_SEXP
			-- The nil object
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_NilValue (item)
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
			l_ptr := Rf_install (item, c_str.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	lang2 (a_sexp1, a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_lang2 (item, a_sexp1.item, a_sexp2.item)
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
			l_ptr := Rf_mkString (item, c_str.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	alloc_vector (a_type: INTEGER_64; a_len: INTEGER_64): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_allocVector (item, a_type, a_len)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	try_eval (a_sexp1, a_sexp2: R_SEXP; a_error: POINTER): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_tryEval (item, a_sexp1.item, a_sexp2.item, a_error)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	integer (a_sexp: R_SEXP): R_INTEGER
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_integer (item, a_sexp.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	real (a_sexp: R_SEXP): R_REAL
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_real (item, a_sexp.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	length (a_sexp: R_SEXP): INTEGER
			--  length of a vector.
		do
			Result := Rf_length (item, a_sexp.item)
		end

	mk_char (a_str: STRING): R_SEXP
			-- character vector
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_mkChar (item, (create {C_STRING}.make (a_str)).item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_string_etl (a_x: R_SEXP; a_index: INTEGER; a_v: R_SEXP)
		do
			R_SET_STRING_ELT (item, a_x.item, a_index, a_v.item)
		end

	vector_elt (a_sexp: R_SEXP; a_index: INTEGER): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_VECTOR_ELT (item, a_sexp.item, a_index)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	print_value (a_sexp: R_SEXP)
		do
			Rf_PrintValue (item, a_sexp.item)
		end

	eval (a_sexp1, a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_eval (item, a_sexp1.item, a_sexp2.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	type_of (a_sexp: R_SEXP): INTEGER
		do
			Result := TYPEOF (item, a_sexp.item)
		end

	find_fun (a_sexp: R_SEXP; a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_findFun (item, a_sexp.item, a_sexp2.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	scalar_integer (a_integer: INTEGER): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := Rf_ScalarInteger (item, a_integer)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

feature -- Access: Rinternals List access functions

	set_car (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := setcar (item, a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cdr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := setcdr (item, a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cadr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := setcadr (item, a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_caddr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := setcaddr (item, a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cadddr (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := setcadddr (item, a_x.item, a_y.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	set_cad4r (a_x: R_SEXP; a_y: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := setcad4r (item, a_x.item, a_y.item)
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
			l_ptr := R_ParseVector (item, a_sexp.item, a_int, a_status, a_sexp2.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

feature -- Access: Rinternals - Evaluation Environment

	global_env: R_SEXP
			-- The "global" environment
		local
			l_ptr: POINTER
		do
			create Result.make
			l_ptr := R_GlobalEnv (item)
			if l_ptr /= default_pointer then
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
			l_ptr := Rf_protect (item, a_sexp.item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	unprotect (n: INTEGER)
			-- Release the `n` objects last added to the protection stack.
		do
			Rf_unprotect (item, n)
		end

feature {NONE} -- C API

	R_initEmbeddedR_default (a_handle: POINTER): INTEGER
			-- Defined as int Rf_initEmbeddedR(int argc, char *argv[]);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rembedded.h>, <Rdefines.h>"
		alias
			"[
				FARPROC Rf_initEmbeddedR = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_initEmbeddedR = GetProcAddress (user32_module, "Rf_initEmbeddedR");
				if (Rf_initEmbeddedR) {
					//char *r_argv[] = { "R", "--silent" };
					 char *r_argv[] = { (char *) "REmbedded", (char *) "--slave" };
					return (FUNCTION_CAST_TYPE(int, STDAPIVCALLTYPE, (int, char*)) Rf_initEmbeddedR) ( 2, r_argv );
				} else {
					return -1;
				}
			]"
		end

	getDLLVersion (a_handle: POINTER): POINTER
			-- Defined as int Rf_initEmbeddedR(int argc, char *argv[]);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rembedded.h>"
		alias
			"[
				FARPROC getDLLVersion = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				getDLLVersion = GetProcAddress (user32_module, "getDLLVersion");
				if (getDLLVersion) {
					return (FUNCTION_CAST_TYPE(char *, STDAPIVCALLTYPE, (void)) getDLLVersion) ( );
				} else {
					return NULL;
				}
			]"
		end

	R_tryEval (a_handle: POINTER; a_sexp1, a_sexp2: POINTER; error: POINTER): POINTER
			-- Defined as SEXP Rf_lang2(SEXP, SEXP);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC R_tryEval = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				R_tryEval = GetProcAddress (user32_module, "R_tryEval");
				if (R_tryEval) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP, int *)) R_tryEval) ((SEXP)$a_sexp1, (SEXP)$a_sexp2, (int *)$error );
				} else {
					return NULL;
				}
			]"
		end

	R_GlobalEnv (a_handle: POINTER): POINTER
			-- LibExtern SEXP	R_GlobalEnv;
			-- The "global" environment
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				SEXP *R_GlobalEnv = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				R_GlobalEnv = GetProcAddress (user32_module, "R_GlobalEnv");
				if (R_GlobalEnv) {
					return *R_GlobalEnv;
				} else {
					return NULL;
				}
			]"
		end

	Rf_install (a_handle: POINTER; a_ptr: POINTER): POINTER
			-- Defined as SEXP Rf_install(const char *);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_install = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_install = GetProcAddress (user32_module, "Rf_install");
				if (Rf_install) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (const char *)) Rf_install) ($a_ptr);
				} else {
					return NULL;
				}
			]"
		end

	Rf_lang2 (a_handle: POINTER; a_sexp1, a_sexp2: POINTER): POINTER
			-- Defined asSEXP Rf_lang2(SEXP, SEXP);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_lang2 = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_lang2 = GetProcAddress (user32_module, "Rf_lang2");
				if (Rf_lang2) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) Rf_lang2) ((SEXP)$a_sexp1, (SEXP)$a_sexp2);
				} else {
					return NULL;
				}
			]"
		end

	Rf_allocVector (a_handle: POINTER; a_type: INTEGER_64; a_leng: INTEGER_64): POINTER
			-- Defined asSEXP	 Rf_lang2(SEXP, SEXP);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_allocVector = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_allocVector = GetProcAddress (user32_module, "Rf_allocVector");
				if (Rf_allocVector) {
					  return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXPTYPE, R_xlen_t)) Rf_allocVector) ((SEXPTYPE)$a_type, (R_xlen_t)$a_leng);
				} else {
					  return NULL;
				}
			]"
		end

	Rf_protect (a_handle: POINTER; a_ptr: POINTER): POINTER
			-- Defined as SEXP Rf_protect(SEXP);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_protect = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_protect = GetProcAddress (user32_module, "Rf_protect");
				if (Rf_protect) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP)) Rf_protect) ($a_ptr);
				} else {
					return NULL;
				}
			]"
		end

	Rf_unprotect (a_handle: POINTER; a_val: INTEGER)
			-- Defined UNPROTECT(n)	Rf_unprotect(n)
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_unprotect = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_unprotect = GetProcAddress (user32_module, "Rf_unprotect");
				if (Rf_unprotect) {
					(FUNCTION_CAST_TYPE(void, STDAPIVCALLTYPE, (int)) Rf_unprotect) ($a_val);
				}
			]"
		end

	Rf_mkString (a_handle: POINTER; a_ptr: POINTER): POINTER
			-- Defined as SEXP Rf_mkString(const char *);
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_mkString = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_mkString = GetProcAddress (user32_module, "Rf_mkString");
				if (Rf_mkString) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (const char *)) Rf_mkString) ($a_ptr);
				} else {
					return NULL;
				}
			]"
		end

	Rf_endEmbeddedR (a_handle: POINTER)
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rembedded.h>, <Rdefines.h>"
		alias
			"[
				FARPROC Rf_endEmbeddedR = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_endEmbeddedR = GetProcAddress (user32_module, "Rf_endEmbeddedR");
				if (Rf_endEmbeddedR) {
					(FUNCTION_CAST_TYPE(void, STDAPIVCALLTYPE, (int)) Rf_endEmbeddedR) ( 0 );
				}
			]"
		end

	R_setStartTime (a_handle: POINTER)
		require
			a_api_exists: a_handle /= default_pointer
		external
			"C inline use <Rembedded.h>"
		alias
			"[
				FARPROC R_setStartTime = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				R_setStartTime = GetProcAddress (user32_module, "R_setStartTime");
				if (R_setStartTime) {
					(FUNCTION_CAST_TYPE(void, STDAPIVCALLTYPE,(void)) R_setStartTime) ( );
				}
			]"
		end

	R_integer (a_handle: POINTER; arg: POINTER): POINTER
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC ptr = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				ptr = GetProcAddress (user32_module, "DATAPTR");
				if (ptr) {
					return (int *)(*ptr)((SEXP)$arg);
				} else {
					return NULL;
				}
			]"
		end

	R_real (a_handle: POINTER; arg: POINTER): POINTER
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC ptr = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				ptr = GetProcAddress (user32_module, "DATAPTR");
				if (ptr) {
					return (double *)(*ptr)((SEXP)$arg);
				} else {
					return NULL;
				}
			]"
		end

	Rf_length (a_handle: POINTER; arg: POINTER): INTEGER
			-- R_len_t  Rf_length(SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_length = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_length = GetProcAddress (user32_module, "Rf_length");
				if (Rf_length) {
					return (FUNCTION_CAST_TYPE(R_len_t, STDAPIVCALLTYPE, (SEXP)) Rf_length) ($arg);
				} else {
					return 0;
				}
			]"
		end

	R_NilValue (a_handle: POINTER): POINTER
			-- LibExtern SEXP	R_NilValue;
			-- The nil object
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				SEXP *R_NilValue = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				R_NilValue = GetProcAddress (user32_module, "R_NilValue");
				if (R_NilValue) {
					return *R_NilValue;
				} else {
					return NULL;
				}
			]"
		end

	Rf_mkChar (a_handle: POINTER; arg: POINTER): POINTER
			-- SEXP Rf_mkChar(const char *);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_mkChar = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_mkChar = GetProcAddress (user32_module, "Rf_mkChar");
				if (Rf_mkChar) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP)) Rf_mkChar) ($arg);
				} else {
					return NULL;
				}
			]"
		end

	R_SET_STRING_ELT (a_handle: POINTER; a_x: POINTER; a_i: INTEGER; a_v: POINTER)
			-- void SET_STRING_ELT(SEXP x, R_xlen_t i, SEXP v);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC SET_STRING_ELT = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				SET_STRING_ELT = GetProcAddress (user32_module, "SET_STRING_ELT");
				if (SET_STRING_ELT) {
					(FUNCTION_CAST_TYPE(void, STDAPIVCALLTYPE, (SEXP, R_xlen_t, SEXP )) SET_STRING_ELT) ($a_x, $a_i, $a_v);
				}
			]"
		end

	R_VECTOR_ELT (a_handle: POINTER; a_sexp: POINTER; a_index: INTEGER): POINTER
			--  VECTOR_ELT(x,i)	((SEXP *) DATAPTR(x))[i]
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC VECTOR_ELT = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				VECTOR_ELT = GetProcAddress (user32_module, "VECTOR_ELT");
				if (VECTOR_ELT) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, R_xlen_t)) VECTOR_ELT) ( $a_sexp, $a_index );
				} else {
					return NULL;
				}
			]"
		end

	Rf_PrintValue (a_handle: POINTER; a_val: POINTER)
			-- void Rf_PrintValue(SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_PrintValue = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_PrintValue = GetProcAddress (user32_module, "Rf_PrintValue");
				if (Rf_PrintValue) {
					(FUNCTION_CAST_TYPE(void, STDAPIVCALLTYPE, (SEXP)) Rf_PrintValue) ( $a_val );
				}
			]"
		end

	Rf_eval (a_handle: POINTER; a_x: POINTER; a_y: POINTER): POINTER
			-- SEXP Rf_eval(SEXP, SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_eval = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_eval = GetProcAddress (user32_module, "Rf_eval");
				if (Rf_eval) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) Rf_eval) ( $a_x, $a_y );
				} else {
					return NULL;
				}
			]"
		end

	R_ParseVector (a_handle: POINTER; arg: POINTER; int: INTEGER; status: POINTER; arg2: POINTER): POINTER
			-- SEXP R_ParseVector(SEXP, int, ParseStatus *, SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				// Workaround can't include the header <R-ext/Parse.h>, since 
				// it cause a C syntaxt error, maybe it`s caused by a circular include dependency.
				// or we need to use GetProcAddress to get the enum.
				FARPROC R_ParseVector = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				R_ParseVector = GetProcAddress (user32_module, "R_ParseVector");
				if (R_ParseVector) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, int, int *, SEXP)) R_ParseVector) ($arg, $int, $status, $arg2);
				} else {
					return NULL;
				}
			]"
		end

	TYPEOF (a_handle: POINTER; a_x: POINTER): INTEGER
			-- TYPEOF(x)	((x)->sxpinfo.type)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC TYPEOF = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				TYPEOF = GetProcAddress (user32_module, "TYPEOF");
				if (TYPEOF) {
					return (FUNCTION_CAST_TYPE(SEXPTYPE, STDAPIVCALLTYPE, (SEXP)) TYPEOF) ($a_x);
				} else {
					return -1;
				}
			]"
		end

	Rf_findFun (a_handle: POINTER; a_x: POINTER; a_y: POINTER): POINTER
			-- SEXP Rf_findFun(SEXP, SEXP);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_findFun = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_findFun = GetProcAddress (user32_module, "Rf_findFun");
				if (Rf_findFun) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP,SEXP)) Rf_findFun) ($a_x, $a_y);
				} else {
					return NULL;
				}
			]"
		end

	Rf_ScalarInteger (a_handle: POINTER; a: INTEGER): POINTER
			-- SEXP	 Rf_ScalarInteger(int);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC Rf_ScalarInteger = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				Rf_ScalarInteger = GetProcAddress (user32_module, "Rf_ScalarInteger");
				if (Rf_ScalarInteger) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (int)) Rf_ScalarInteger) ($a);
				} else {
					return NULL;
				}
			]"
		end


	SETCAR (a_handle: POINTER; x: POINTER; y: POINTER): POINTER
			-- SEXP SETCAR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC SETCAR = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				SETCAR = GetProcAddress (user32_module, "SETCAR");
				if (SETCAR) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) SETCAR) ($x, $y);
				} else {
					return NULL;
				}
			]"
		end

	SETCDR (a_handle: POINTER; x: POINTER; y: POINTER): POINTER
			-- SEXP SETCDR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC SETCDR = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				SETCDR = GetProcAddress (user32_module, "SETCDR");
				if (SETCDR) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) SETCDR) ($x, $y);
				} else {
					return NULL;
				}
			]"
		end


	SETCADR (a_handle: POINTER; x: POINTER; y: POINTER): POINTER
			-- SEXP SETCADR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC SETCADR = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				SETCADR = GetProcAddress (user32_module, "SETCADR");
				if (SETCADR) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) SETCADR) ($x, $y);
				} else {
					return NULL;
				}
			]"
		end

	SETCADDR (a_handle: POINTER; x: POINTER; y: POINTER): POINTER
			-- SEXP SETCADDR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC SETCADDR = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				SETCADDR = GetProcAddress (user32_module, "SETCADDR");
				if (SETCADDR) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) SETCADDR) ($x, $y);
				} else {
					return NULL;
				}
			]"
		end

	SETCADDDR (a_handle: POINTER; x: POINTER; y: POINTER): POINTER
			-- SEXP SETCADDDR(SEXP x, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC SETCADDDR = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				SETCADDDR = GetProcAddress (user32_module, "SETCADDDR");
				if (SETCADDDR) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) SETCADDDR) ($x, $y);
				} else {
					return NULL;
				}
			]"
		end

	SETCAD4R (a_handle: POINTER; x: POINTER; y: POINTER): POINTER
			-- SEXP SETCAD4R(SEXP e, SEXP y);
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC SETCAD4R = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				SETCAD4R = GetProcAddress (user32_module, "SETCAD4R");
				if (SETCAD4R) {
					return (FUNCTION_CAST_TYPE(SEXP, STDAPIVCALLTYPE, (SEXP, SEXP)) SETCAD4R) ($x, $y);
				} else {
					return NULL;
				}
			]"
		end
end
