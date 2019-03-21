note
	description: "[
		Display game board
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOARD
inherit
	ANY
		redefine out end

create
	make

feature {NONE} -- create

	make(a_size: INTEGER)
		do
			size := a_size


			create implementation.make_filled ('_',size, size)
			--create king_position.make (1, 1)
			--implementation.put ('K', 1, 1)
			--create bishop_position.make (size, size)
			--implementation.put ('B', size, size)

			create fire_coord.make (1, 1)
			create bomb_coord1.make (1, 1)
			create bomb_coord2.make (1, 1)


			create history.make
		end


feature {MOVE} -- implementation
	implementation: ARRAY2[CHARACTER]


feature  -- game started
	size: INTEGER
		-- size of board

    started: BOOLEAN
    	-- has the game started?

    set_started
    	do
        	started := True
    	end

feature -- coords
	fire_coord: COORD
	bomb_coord1: COORD
	bomb_coord2: COORD

feature -- history
 	history: HISTORY

feature -- out

    board_out: STRING
			-- representation of board
		do
			Result := "  "
			across 1 |..| size as h loop
				across 1 |..| size as w loop
					Result := Result + "  " + implementation[h.item, w.item].out
				end
				Result := Result + "%N  "
			end
			Result := Result.substring (1, Result.count-3)
		end

    out: STRING
			-- representation of board
		do
			Result := ""
			if started then
				Result := board_out
			end
		end
end
