note
	description: "Alphabet allowed to appear on a battleship board."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHIP_ALPHABET

inherit
	ANY
		redefine
			out
		end

create
	make

feature -- Commands

	make (a_char: CHARACTER)
		do
			item := a_char
		end

feature -- Attributes

	item: CHARACTER


feature -- output

	out: STRING
			-- Return string representation of alphabet.
		do
			Result := item.out
		end

invariant
	allowable_symbols:
		item = '_' or item = 'h' or item = 'v' or item = 'O' or item = 'X'
end
