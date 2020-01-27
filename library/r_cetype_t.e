note
	description: "{R_CETYPE_T}  object representing an enum of encoding associated with CHARSXP."
	date: "$Date$"
	revision: "$Revision$"

class
	R_CETYPE_T

feature -- Access: Enum values

	CE_NATIVE: INTEGER = 0
	CE_UTF8: INTEGER = 1
	CE_LATIN1: INTEGER = 2
	CE_BYTES: INTEGER = 3
	CE_SYMBOL: INTEGER = 5
	CE_ANY: INTEGER = 99

feature -- Contract Support

	is_valid (a_value: INTEGER): BOOLEAN
			-- is value `a_value` a valid encoding?
		do
			inspect a_value
			when CE_NATIVE then
				Result := True
			when CE_UTF8 then
				Result := True
			when CE_LATIN1 then
				Result := True
			when CE_BYTES then
				Result := True
			when CE_SYMBOL then
				Result := True
			when CE_ANY then
				Result := True
			else
				Result := False
			end
		end

end

