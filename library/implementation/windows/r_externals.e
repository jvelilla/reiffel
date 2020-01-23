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

	try_eval (a_sexp1, a_sexp2: R_SEXP; a_error: TYPED_POINTER[INTEGER]): R_SEXP
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
		local
			l_ptr: POINTER
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

	R_tryEval (a_handle: POINTER; a_sexp1, a_sexp2: POINTER; error: TYPED_POINTER [INTEGER]): POINTER
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

end
