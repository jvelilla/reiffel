note
	description: "Object that provides detailed information about the version of R running."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Rversion", "src=https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/R.Version", "protocol=uri"

class
	R_VERSION

feature -- R version

	R_version: INTEGER
		external
			"C inline use <Rversion.h>"
		alias
			"R_VERSION"
		end

	R_nick: STRING
		do
			Result := (create {C_STRING}.make_by_pointer (c_r_nick)).string
		end

	R_major: STRING
		do
			Result := (create {C_STRING}.make_by_pointer (c_r_major)).string
		end

	R_minor: STRING
		do
			Result := (create {C_STRING}.make_by_pointer (c_r_minor)).string
		end

	R_year: STRING
		do
			Result := (create {C_STRING}.make_by_pointer (c_r_year)).string
		end

	R_month: STRING
		do
			Result := (create {C_STRING}.make_by_pointer (c_r_month)).string
		end

	R_day: STRING
		do
			Result := (create {C_STRING}.make_by_pointer (c_r_day)).string
		end


feature {NONE} -- C Rversion

	c_r_nick: POINTER
		external
			"C inline use <Rversion.h>"
		alias
			"R_NICK"
		end

	c_r_major: POINTER
		external
			"C inline use <Rversion.h>"
		alias
			"R_MAJOR"
		end

	c_r_minor: POINTER
		external
			"C inline use <Rversion.h>"
		alias
			"R_MINOR"
		end

	c_r_year: POINTER
		external
			"C inline use <Rversion.h>"
		alias
			"R_YEAR"
		end

	c_r_month: POINTER
		external
			"C inline use <Rversion.h>"
		alias
			"R_MONTH"
		end

	c_r_day: POINTER
		external
			"C inline use <Rversion.h>"
		alias
			"R_DAY"
		end

end
