note
	description: "Summary description for {R_PARSE_STATUS_ENUM}."
	date: "$Date$"
	revision: "$Revision$"

class
	R_PARSE_STATUS_ENUM

feature -- Access

	PARSE_NULL: INTEGER = 0
--		external
--			"C inline use <R_ext/Parse.h>"
--		alias
--			"PARSE_NULL"
--		end

	PARSE_OK: INTEGER = 1
--		external
--			"C inline use <R_ext/Parse.h>"
--		alias
--			"PARSE_OK"
--		end

	PARSE_INCOMPLETE: INTEGER = 2
--		external
--			"C inline use <R_ext/Parse.h>"
--		alias
--			"PARSE_INCOMPLETE"
--		end

	PARSE_ERROR: INTEGER = 3
--		external
--			"C inline use <R_ext/Parse.h>"
--		alias
--			"PARSE_ERROR"
--		end

	PARSE_EOF: INTEGER = 4
--		external
--			"C inline use <R_ext/Parse.h>"
--		alias
--			"PARSE_EOF"
--		end

feature -- Contract Support

	is_valid_status (a_value: INTEGER): BOOLEAN
			-- Is value `a_value` a valid prase status?
		do
			Result := a_value = Parse_null or else a_value = Parse_ok or else
				a_value = Parse_incomplete or else a_value = Parse_error or else
				a_value = Parse_eof
		end

end
