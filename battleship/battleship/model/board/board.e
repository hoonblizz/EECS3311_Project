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

			-- init. Shouldn't be actually used for undo, redo
			create coord_fire.make (1, 1)
			create coord_bomb1.make (1, 1)
			create coord_bomb2.make (1, 1)



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


feature -- history
 	history: HISTORY

feature -- game data
	gamedata: GAMEDATA

feature -- variables for record coords
	-- used in OPERATION_FIRE and OPERATION_BOMB for track of 'old position'
	coord_fire: COORD
	coord_bomb1: COORD
	coord_bomb2: COORD

feature -- marking on board
	-- At this point, assume all error cases are handled. (in ETF)
	mark_on_board(coord: COORD)
		do
			if check_coord_is_hit(coord) > 0 then
				implementation.put ('X', coord.x.item, coord.y.item)
			else
				implementation.put ('O', coord.x.item, coord.y.item)
			end
		end

	mark_fire(coord: COORD)
		do
			mark_on_board(coord)
		end

	mark_bomb(coord1: COORD; coord2: COORD)
		do
			mark_on_board(coord1)
			mark_on_board(coord2)
		end

	mark_empty(coord: COORD)
		do
			implementation.put ('_', coord.x.item, coord.y.item)
		end

feature -- check

	-- Go through all ships any check any of them is hit
	-- if sunk, return 'ship size'  <--- important!!
	-- if just hit, return 0.
	-- Because just hit and sink have different messages (used in ETF_FIRE)
	check_coord_is_hit(coord: COORD): INTEGER
		local
			tempRow, tempCol: INTEGER
			tempCoord: COORD
			matchedShipSize: INTEGER
		do
			matchedShipSize := 0

			across gamedata.generated_ships as ship loop
				tempRow := ship.item.row
				tempCol := ship.item.col

				across 1 |..| ship.item.size as j loop
					-- Check if any coord of ship is matching
					create tempCoord.make (tempRow, tempCol)
					if tempCoord ~ coord then
						matchedShipSize := ship.item.size
					end
					if ship.item.dir then
						tempRow := tempRow + 1
					else
						tempCol := tempCol + 1
					end
				end
			end
		end

	check_ship_already_hit(coord: COORD): BOOLEAN
		do
			-- this is for 'already fired coord'
			if implementation[coord.x, coord.y] ~ 'X' or implementation[coord.x, coord.y] ~ 'O' then
				Result := True
			else
				Result := False
			end
		end

	-- Compare implementation coord and Ship Coord to define if ship is sunk.
	check_ship_sunk(ship: TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]): BOOLEAN
		local
			numOfHit: INTEGER
			coord: COORD
			coord_x, coord_y: INTEGER
		do
			numOfHit := 0
			coord_x := ship.row.item
			coord_y := ship.col.item

			across 1 |..| ship.size as i loop

				print("%NImple Coord check: [" + ship.row.out + ", " + ship.col.out + "] " + implementation[ship.row.item, ship.col.item].out)

				-- based on dir, add to coor
				if ship.dir.item then	coord_x := coord_x + 1
				else coord_y := coord_y + 1
				end

				create coord.make (coord_x, coord_y)

				if check_ship_already_hit(coord) then -- hit
					numOfHit := numOfHit + 1
				end
			end

			print("%NCheck for Full Hit: " + numOfHit.out + " / " + ship.size.out)

			if ship.size ~ numOfHit then		-- Full hit
				Result := True
			else
				Result := False
			end

		end

	-- Used to decide messages after fire, bomb execution
	-- mixture of 'check_coord_is_hit' and 'check_ship_sunk'
	-- ASSUME coord was a hit.
	check_hit_caused_sink(coord: COORD): BOOLEAN
		local
			shipSize: INTEGER
			sunk: BOOLEAN
		do
			sunk := False
			shipSize := check_coord_is_hit(coord)

			across gamedata.generated_ships as ship loop
				if ship.item.size ~ shipSize then
					sunk := check_ship_sunk(ship.item)
				end
			end

			Result := sunk
		end

feature -- check errors in commands
	check_invalid_coord(coord: COORD): BOOLEAN
		do
			--print("%Ncheck_invalid_coord: " + coord.x.out + ", " + coord.y.out + " in " + gamedata.current_board_size.out)
			Result := not (coord.x <= gamedata.current_board_size and coord.y <= gamedata.current_board_size)
		end

	check_already_fired(coord: COORD): BOOLEAN
		do
			-- See if coord is already 'marked'
			Result := check_ship_already_hit(coord)
		end

	-- This is AFTER executing commad. Checking if it was a hit not miss.
	check_if_it_was_hit(coord: COORD): BOOLEAN
		do
			if implementation[coord.x, coord.y] ~ 'X' then
				Result := True
			elseif implementation[coord.x, coord.y] ~ 'O' then
				Result := False
			else		-- Shouldn't be happening
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
