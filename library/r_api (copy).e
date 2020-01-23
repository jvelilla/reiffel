note
	description: "Summary description for {R_API}."
	date: "$Date$"
	revision: "$Revision$"

class
	R_API_OLD

inherit

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

	is_r_installed: BOOLEAN
		do
			Result := not item.is_default_pointer
		end

	has_error: BOOLEAN
			-- the last operation was successful?
			--| TODO better error handling.

feature -- Access

	item: POINTER
			-- R handle.

	init_embedded_r_default
			-- Intialize the embedded R environment in silent mode.
		local
			r: INTEGER
		do
			if is_r_installed then
				r := R_initEmbeddedR_default (item)
			end
		end

	end_embedded_r
			-- Release R environment
		do
			if is_r_installed then
				Rf_endEmbeddedR (item)
			end
		end

	start_time
		do
			if is_r_installed then
				R_setStartTime (item)
			end
		end

	dll_version: STRING
		local
			l_ptr: POINTER
		do
			if is_r_installed then
				l_ptr := getDLLVersion (item)
				if l_ptr /= default_pointer then
					Result := (create {C_STRING}.make_by_pointer (l_ptr)).string
				else
					Result := "Unknown"
				end
			else
				Result := "Unknown"
			end
		end

	Rf_install (a_str: STRING): R_SEXP
		local
			c_str: C_STRING
			l_ptr: POINTER
		do
			has_error := False
			create Result.make
			if is_r_installed then
				create c_str.make (a_str)
				l_ptr := crf_install (item, c_str.item)
				if l_ptr /= default_pointer then
					create Result.make_by_pointer (l_ptr)
				else
					has_error := True
				end
			end
		end

	Rf_mkString (a_str: STRING): R_SEXP
		local
			c_str: C_STRING
			l_ptr: POINTER
		do
			has_error := False
			create Result.make
			if is_r_installed then
				create c_str.make (a_str)
				l_ptr := crf_mkstring (item, c_str.item)
				if l_ptr /= default_pointer then
					create Result.make_by_pointer (l_ptr)
				else
					has_error := True
				end
			end
		end

	Rf_lang2 (a_sexp1, a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
		do
			has_error := False
			create Result.make
			if is_r_installed then
				l_ptr := crf_lang2 (item, a_sexp1.item, a_sexp2.item)
				if l_ptr /= default_pointer then
					create Result.make_by_pointer (l_ptr)
				else
					has_error := True
				end
			end
		end

	Rf_allocVector (a_type: INTEGER_64; a_len: INTEGER_64): R_SEXP
		local
			l_ptr: POINTER
		do
			has_error := False
			create Result.make
			if is_r_installed then
				l_ptr := cRf_allocVector (item, a_type, a_len)
				if l_ptr /= default_pointer then
					create Result.make_by_pointer (l_ptr)
				else
					has_error := True
				end
			end
		end

	R_GlobalEnv: R_SEXP
		local
			l_ptr: POINTER
		do
			has_error := False
			create Result.make
			if is_r_installed then
				l_ptr := cR_GlobalEnv (item)
				if l_ptr /= default_pointer then
					create Result.make_by_pointer (l_ptr)
				else
					has_error := True
				end
			end
		end

	R_try_eval (a_sexp1, a_sexp2: R_SEXP): R_SEXP
		local
			l_ptr: POINTER
			error: INTEGER
		do
			has_error := False
			create Result.make
			if is_r_installed then
				l_ptr := cR_tryeval (item, a_sexp1.item, a_sexp2.item, $error)
				if l_ptr /= default_pointer then
					create Result.make_by_pointer (l_ptr)
				else
					has_error := True
				end
			end
		end

	R_integer (a_sexp: R_SEXP): POINTER
		do
			if is_r_installed then
				Result := cR_integer (item, a_sexp.item)
			end
		end

	R_real (a_sexp: R_SEXP): POINTER
		do
			if is_r_installed then
				Result := cr_real (item, a_sexp.item)
			end
		end

feature -- Pointer Protection and Unprotection

	Rf_protect (a_sexp: R_SEXP): R_SEXP
			-- Put the `a_sepx` R object to the short-term
			-- stack of objects protected from garbase collection
		local
			l_ptr: POINTER
		do
			has_error := False
			create Result.make
			if is_r_installed then
				l_ptr := cRf_protect (item, a_sexp.item)
				if l_ptr /= default_pointer then
					create Result.make_by_pointer (l_ptr)
				else
					has_error := True
				end
			end
		end

	Rf_unprotect (n: INTEGER)
			-- Release the `n` objects last added to the protection stack.
		local
			l_ptr: POINTER
		do
			if is_r_installed then
				cRf_unprotect (item, n)
			end
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
					char *r_argv[] = { "R", "--silent" };
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

	cR_tryEval (a_handle: POINTER; a_sexp1, a_sexp2: POINTER; error: POINTER): POINTER
			-- Defined asSEXP	 Rf_lang2(SEXP, SEXP);
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

	cR_GlobalEnv (a_handle: POINTER): POINTER
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

	cRf_install (a_handle: POINTER; a_ptr: POINTER): POINTER
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

	cRf_lang2 (a_handle: POINTER; a_sexp1, a_sexp2: POINTER): POINTER
			-- Defined asSEXP	 Rf_lang2(SEXP, SEXP);
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

	cRf_allocVector (a_handle: POINTER; a_type: INTEGER_64; a_leng: INTEGER_64): POINTER
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

	cRf_protect (a_handle: POINTER; a_ptr: POINTER): POINTER
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

	cRf_unprotect (a_handle: POINTER; a_val: INTEGER)
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

	cRf_mkString (a_handle: POINTER; a_ptr: POINTER): POINTER
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

	cR_integer (a_handle: POINTER; arg: POINTER): POINTER
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

	cR_real (a_handle: POINTER; arg: POINTER): POINTER
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

	cR_real_value (a_handle: POINTER; arg: POINTER; i: INTEGER): REAL_64
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				return *(double *) $arg + $i;
			]"
		end

	copy_integer_array_to_r (a_handle: POINTER; arg: POINTER; a: POINTER; alen: INTEGER)
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC ptr = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				ptr = GetProcAddress (user32_module, "DATAPTR");
				if (ptr) {
					memcpy((int *)(*ptr)((SEXP)$arg), $a, $alen * sizeof(int));
				}
			]"
		end

	cRvector_elt (a_handle: POINTER; arg: POINTER; i: INTEGER): POINTER
		external
			"C inline use <Rinternals.h>"
		alias
			"[
				FARPROC ptr = NULL;
				HMODULE user32_module = (HMODULE) $a_handle;
				ptr = GetProcAddress (user32_module, "DATAPTR");
				if (ptr) {
					return  (((SEXP *)((*ptr)((SEXP)$arg)))[$i]);
				}
			]"
		end

feature -- R version

	R_version: INTEGER
		require
			a_api_exists: item /= default_pointer
		external
			"C inline use <Rversion.h>"
		alias
			"R_VERSION"
		end

feature {NONE} -- C Rversion

	c_r_nick: POINTER
		require
			a_api_exists: item /= default_pointer
		external
			"C inline use <Rversion.h>"
		alias
			"R_NICK"
		end

	c_r_major: POINTER
		require
			a_api_exists: item /= default_pointer
		external
			"C inline use <Rversion.h>"
		alias
			"R_MAJOR"
		end

	c_r_minor: POINTER
		require
			a_api_exists: item /= default_pointer
		external
			"C inline use <Rversion.h>"
		alias
			"R_MINOR"
		end

	c_r_year: POINTER
		require
			a_api_exists: item /= default_pointer
		external
			"C inline use <Rversion.h>"
		alias
			"R_YEAR"
		end

	c_r_month: POINTER
		require
			a_api_exists: item /= default_pointer
		external
			"C inline use <Rversion.h>"
		alias
			"R_MONTH"
		end

	c_r_day: POINTER
		require
			a_api_exists: item /= default_pointer
		external
			"C inline use <Rversion.h>"
		alias
			"R_DAY"
		end

end
