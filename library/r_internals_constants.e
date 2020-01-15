note
	description: "Constants from the file Rinternals.h "
	date: "$Date$"
	revision: "$Revision$"

class
	R_INTERNALS_CONSTANTS

feature -- Access

	nilsxp: INTEGER_64 = 0
			-- nil = NULL

	symsxp: INTEGER_64 = 1
			-- symbols

	listsxp: INTEGER_64 = 2
			-- lists of dotted pairs

	closxp: INTEGER_64 = 3
			-- closures

	envsxp: INTEGER_64 = 4
			-- environments

	promsxp: INTEGER_64 = 5
			-- promises: [un]evaluated closure arguments

	langsxp: INTEGER_64 = 6
			-- language constructs (special lists)

	specialsxp: INTEGER_64 = 7
			-- special forms

	builtinsxp: INTEGER_64 = 8
			-- builtin non-special forms

	charsxp: INTEGER_64 = 9
			-- "scalar" string type (internal only)

	lglsxp: INTEGER_64 = 10
			-- logical vectors

	intsxp: INTEGER_64 = 13
			-- integer vectors

	realsxp: INTEGER_64 = 14
			-- real variables

	cplxsxp: INTEGER_64 = 15
			-- complex variables

	strsxp: INTEGER_64 = 16
			-- string vectors

	dotsxp: INTEGER_64 = 17
			-- dot-dot-dot object

	anysxp: INTEGER_64 = 18
			-- make "any" args work.
			-- Used in specifying types for symbol
			-- registration to mean anything is okay

	vecsxp: INTEGER_64 = 19
			-- generic vectors

	exprsxp: INTEGER_64 = 20
			-- expressions vectors

	bcodesxp: INTEGER_64 = 21
			-- byte code

	extptrsxp: INTEGER_64 = 22
			-- external pointer

	weakrefsxp: INTEGER_64 = 23
			-- weak reference

	rawsxp: INTEGER_64 = 24
			-- raw bytes

	s4sxp: INTEGER_64 = 25
			-- S4, non-vector

	newsxp: INTEGER_64 = 30
			-- fresh node created in new page

	freesxp: INTEGER_64 = 31
			-- node released by GC

	funsxp: INTEGER_64 = 99
			-- Closure or Builtin or Special

	type_bits: INTEGER_64 = 5

	max_num_sexptype: INTEGER_64
		do
			Result := 1 |<< 5
		ensure
			is_class: class
		end

	named_bits: INTEGER_64 = 16

	missing_mask: INTEGER_64 = 15
			-- reserve 4 bits--only 2 uses now

	ddval_mask: INTEGER_64 = 1

	namedmax: INTEGER_64 = 7

		-- Save/Load Interface
	r_xdr_double_size: INTEGER_64 = 8

	r_xdr_integer_size: INTEGER_64 = 4

	r_codeset_max: INTEGER_64 = 63

feature {NONE} -- C externals

end
