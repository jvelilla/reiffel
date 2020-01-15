note
	description: "Summary description for {R_ENVIRONMENT}."
	date: "$Date$"
	revision: "$Revision$"

class
	R_ENVIRONMENT

inherit

	R_API

create
	initialize

feature {NONE} -- Initialization

	initialize
		do
			init_embedded_r_default
		end


feature -- Release R environment

	finalize
		do
			end_embedded_r
		end
end
