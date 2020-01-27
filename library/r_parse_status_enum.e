note
	description: "Summary description for {R_PARSE_STATUS_ENUM}."
	date: "$Date$"
	revision: "$Revision$"

class
	R_PARSE_STATUS_ENUM

feature -- Access

	PARSE_NULL: INTEGER
		external
			"C inline use <R_ext/Parse.h>"
		alias
			"PARSE_NULL"
		end

	PARSE_OK: INTEGER
		external
			"C inline use <R_ext/Parse.h>"
		alias
			"PARSE_OK"
		end

	PARSE_INCOMPLETE: INTEGER
		external
			"C inline use <R_ext/Parse.h>"
		alias
			"PARSE_INCOMPLETE"
		end

	PARSE_ERROR: INTEGER
		external
			"C inline use <R_ext/Parse.h>"
		alias
			"PARSE_ERROR"
		end

	PARSE_EOF: INTEGER
		external
			"C inline use <R_ext/Parse.h>"
		alias
			"PARSE_EOF"
		end

feature -- Contract Support

	is_valid_status (a_value: INTEGER): BOOLEAN
			-- Is value `a_value` a valid prase status?
		do
			Result := a_value = Parse_null or else a_value = Parse_ok or else
				a_value = Parse_incomplete or else a_value = Parse_error or else
				a_value = Parse_eof
		end

end
