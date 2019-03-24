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

	-- level will be 13, 14, 15, 16 (easy, medium, hard, advanced)
	make(level: INTEGER; debug_mode: BOOLEAN)
		local
			size: INTEGER
			tempRow, tempCol: INTEGER
		do
			debugMode := debug_mode

			create gamedata.make(level, debug_mode)

			size := gamedata.get_board_size (level)

			create implementation.make_filled ('_',size, size)

			-- We now have ships position generated(in game data) and 'implementation'

			-- if debug mode, mark in the position
			if debug_mode then
				across gamedata.generated_ships as ship loop
					tempRow := ship.item.row
					tempCol := ship.item.col
					across 1 |..| ship.item.size as j loop
						if ship.item.dir then
							implementation.put ('v', tempRow, tempCol)
							tempRow := tempRow + 1
						else
							implementation.put ('h', tempRow, tempCol)
							tempCol := tempCol + 1
						end
					end
				end
			end

			-- For fire and bomb, make like this.

			--create king_position.make (1, 1)
			--implementation.put ('K', 1, 1)
			--create bishop_position.make (size, size)
			--implementation.put ('B', size, size)

			create history.make
		end


feature {OPERATION} -- implementation
	implementation: ARRAY2[CHARACTER]


feature  -- game started
	--size: INTEGER
		-- size of board. replacing with gamedata -> current_board_size

    started: BOOLEAN
    	-- has the game started?

    debugMode: BOOLEAN	-- is it debug mode now?

    set_started
    	do
        	started := True
    	end
    set_debugMode
    	do
    		debugMode := True
    	end

--feature -- coords
--	fire_coord: COORD
--	bomb_coord1: COORD
--	bomb_coord2: COORD

feature -- history
 	history: HISTORY

feature -- game data
	gamedata: GAMEDATA

feature -- marking
	mark_fire(coord: COORD)
		do

		end

	makr_bomb(coord1: COORD; coord2: COORD)
		do

		end

feature -- check
	check_ship_hit(coord: COORD): BOOLEAN
		do
			if implementation[coord.x, coord.y] ~ '_' then
				Result := False
			else
				Result := True
			end
		end

	-- Compare implementation coord and Ship Coord to define if ship is sunk.
	check_ship_sunk(ship: TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]): BOOLEAN
		local
			numOfHit: INTEGER
			coord: COORD
		do
			numOfHit := 0
			across 1 |..| ship.size as i loop

				print("%NImple Coord check: [" + ship.row.out + ", " + ship.col.out + "] " + implementation[ship.row.item, ship.col.item].out)

				create coord.make (ship.row.item, ship.col.item)

				if check_ship_hit(coord) then -- hit
					numOfHit := numOfHit + 1
				end
			end

			if ship.size ~ numOfHit then		-- Full hit
				Result := True
			else
				Result := False
			end
		end


feature -- out

    board_out: STRING
			-- representation of board
		local
			size: INTEGER
		do
			size := gamedata.current_board_size
			Result := "     "	-- 5 spaces

			-- Draw Coord (1, 2, 3, 4 ....)
			across 1 |..| size as h loop
				Result := Result + h.item.out
				-- if less than 10, leave 2 spaces. Otherwise, 1 space
				if h.item < 10 then
					Result := Result + "  "
				else
					Result := Result + " "
				end
			end
			Result := Result + "%N  "

			across 1 |..| size as h loop
				-- Draw Coord (A B C D ....)
				Result := Result + gamedata.row_chars[h.item]
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
