note
	description: "Display game board"
	author: "Taehoon Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	BOARD


create
	make

feature {NONE} -- create

	-- level will be 13, 14, 15, 16 (easy, medium, hard, advanced)
	make(level: INTEGER; custom: BOOLEAN; debug_mode: BOOLEAN; generated_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]];
			dimension: INTEGER; ships: INTEGER; max_shots: INTEGER; num_bombs: INTEGER)
		local
			size: INTEGER
			tempRow, tempCol: INTEGER
		do
			debugMode := debug_mode

			numberOfCommand :=0

			create gamedata.make(level, custom, debug_mode, dimension, ships, max_shots, num_bombs)
			gamedata.set_generated_ships (generated_ships)

			--size := gamedata.get_board_size (level)
			size := gamedata.get_current_board_size

			--print("%N***********************")
			--print("%N     Board Create: level: " + level.out + ", size: " + size.out)
			--print(" Custom? " + custom.out + ", Debug? " + debug_mode.out)
			--print("%N***********************%N")

			create implementation.make_filled ('_', size, size)

			-- We now have ships position generated(in game data) and 'implementation'

			-- if debug mode, mark in the position
			if debug_mode then
				--print("%NMarking v and h for board...")
				across gamedata.get_generated_ships as ship loop
					--print("%NShip [" + ship.item.row.out + ", " + ship.item.col.out + "]")
					--print(" Size: "+ ship.item.size.out +", Vertical? " + ship.item.dir.out)
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

			create message.make(level, debug_mode)
			create history.make
		end


feature {OPERATION} -- implementation
	implementation: ARRAY2[CHARACTER]

feature -- call other functions
 	history: HISTORY
 	gamedata: GAMEDATA
	message: MESSAGE


feature {NONE} -- game started

    started: BOOLEAN -- has the game started?
    gameover: BOOLEAN
    debugMode: BOOLEAN	-- is it debug mode now?
	numberOfCommand: INTEGER		-- this gets updated from model, everytime model's numberOfCommand is updated.

feature	-- get, set game starte variables
	get_started: BOOLEAN
		do Result := started end

    set_started
    	do started := True end

    set_not_started
    	do started := False end

	get_gameover: BOOLEAN
		do Result := gameover end

    set_gameover
    	require
    		get_started
    	do
    		gameover := True
    		set_not_started
    		-- transfer values to model is called ETF_FIRE, ETF_BOMB
			-- History clear is also called there

    	end

    set_not_gameover
    	do gameover := False end

    set_debugMode
    	do debugMode := True end

	update_stateNum(val: INTEGER)
		require
			val >= 0
		do
			numberOfCommand := val
		end

	get_numberOfCommand: INTEGER
		do Result := numberOfCommand end



feature {OPERATION} -- command
	-- At this point, assume all error cases are handled. (in ETF)
	mark_on_board(coord: COORD)
		require
			coord.x > 0 and coord.y > 0
			not check_invalid_coord(coord)
			get_started
		do
			if check_coord_is_hit(coord) > 0 then
				implementation.put ('X', coord.x, coord.y)
			else
				implementation.put ('O', coord.x, coord.y)
			end
		end

	mark_fire(coord: COORD)
		require
			coord.x > 0 and coord.y > 0
			not check_invalid_coord(coord)
			get_started
		local
			shipSize: INTEGER
		do
			mark_on_board(coord)
			message.clear_msg_command		-- clear message board before stack

			-- Message is based on whether it's hit or not.
			-- Check if it was a hit
			gamedata.add_shot  -- add for shot

			if check_if_it_was_hit(coord) then

				if check_hit_caused_sink(coord) then
					-- Ship is sunk. Need Size of ship to display
					shipSize := check_coord_is_hit (coord)

					gamedata.add_ship -- add for ship sunk
					gamedata.add_score(shipSize)	-- add for hit score when ship sunk

					message.set_msg_command(gamedata.msg_ship_sunk(shipSize))
					-- if all ships sunk, win.
					if check_win then
						message.set_msg_command (gamedata.msg_win)
						set_gameover
					elseif check_lose then
						message.set_msg_command (gamedata.msg_game_over)
						set_gameover
					else
						message.set_msg_command (gamedata.msg_keep_fire)
					end

				else
					message.set_msg_command(gamedata.msg_hit)

					if check_lose then	-- ship not sunk, so just check for lose
						message.set_msg_command (gamedata.msg_game_over)
						set_gameover
					else
						message.set_msg_command (gamedata.msg_keep_fire)
					end

				end
			else
				message.set_msg_command(gamedata.msg_miss)
				if check_lose then	-- ship not sunk, so just check for lose
					message.set_msg_command (gamedata.msg_game_over)
					set_gameover
				else
					message.set_msg_command (gamedata.msg_keep_fire)
				end
			end

		ensure
			check_fire_happened
		end

	mark_bomb(coord1: COORD; coord2: COORD)
		require
			coord1.x > 0 and coord1.y > 0 and coord2.x > 0 and coord2.y > 0
			not check_invalid_coord(coord1)
			not check_invalid_coord(coord2)
			get_started
		local
			shipSize1,shipSize2: INTEGER
		do
			mark_on_board(coord1)
			mark_on_board(coord2)

			message.clear_msg_command		-- clear message board before stack

			-- Message is based on whether it's hit or not.
			-- Check if it was a hit
			gamedata.add_bomb  -- add for bomb
			shipSize1 := 0
			shipSize2 := 0
			if check_if_it_was_hit(coord1) or check_if_it_was_hit(coord2) then

				if check_if_it_was_hit(coord1) then
					if check_hit_caused_sink(coord1) then
						-- Ship is sunk. Need Size of ship to display
						shipSize1 := check_coord_is_hit (coord1)
					end
				end

				if check_if_it_was_hit(coord2) then
					if check_hit_caused_sink(coord2) then
						shipSize2 := check_coord_is_hit (coord2)
					end
				end

				if shipSize1 > 0 and shipSize2 > 0 and shipSize1 /= shipSize2 then -- both shot caused sink
					gamedata.add_ship -- add for ship sunk
					gamedata.add_ship -- add for ship sunk

					gamedata.add_score(shipSize1)	-- add for hit score when sunk
					gamedata.add_score(shipSize2)

					message.set_msg_command(gamedata.msg_ships_sunk(shipSize1, shipSize2))
					-- if all ships sunk, win.
					if check_win then
						message.set_msg_command (gamedata.msg_win)
						set_gameover
					elseif check_lose then
						message.set_msg_command (gamedata.msg_game_over)
						set_gameover
					else
						message.set_msg_command (gamedata.msg_keep_fire)
					end
				elseif shipSize1 > 0 then
					gamedata.add_ship -- add for ship sunk
					gamedata.add_score(shipSize1)
					message.set_msg_command(gamedata.msg_ship_sunk(shipSize1))
					-- if all ships sunk, win.
					if check_win then
						message.set_msg_command (gamedata.msg_win)
						set_gameover
					elseif check_lose then
						message.set_msg_command (gamedata.msg_game_over)
						set_gameover
					else
						message.set_msg_command (gamedata.msg_keep_fire)
					end
				elseif shipSize2 > 0 then
					gamedata.add_ship -- add for ship sunk
					gamedata.add_score(shipSize2)
					message.set_msg_command(gamedata.msg_ship_sunk(shipSize2))
					-- if all ships sunk, win.
					if check_win then
						message.set_msg_command (gamedata.msg_win)
						set_gameover
					elseif check_lose then
						message.set_msg_command (gamedata.msg_game_over)
						set_gameover
					else
						message.set_msg_command (gamedata.msg_keep_fire)
					end
				else
					-- means just a hit without sink. (Not miss)
					message.set_msg_command (gamedata.msg_hit)
					message.set_msg_command (gamedata.msg_keep_fire)
				end


			else
				message.set_msg_command(gamedata.msg_miss)
				message.set_msg_command (gamedata.msg_keep_fire)
			end

		ensure
			check_fire_happened
		end



feature
	-- for undo, paste AFTER processed board to current board
	paste_on_board(imple: ARRAY2[CHARACTER])
		require
			not imple.is_empty
		do
			implementation.copy (imple)
		ensure
			implementation.same_items (imple)
		end

feature -- query

	-- Go through all ships any check any of them is hit
	-- if sunk, return 'ship size'  <--- important!!
	-- if just hit, return 0.
	-- Because just hit and sink have different messages (used in ETF_FIRE)
	check_coord_is_hit(coord: COORD): INTEGER
		require
			coord.x > 0 and coord.y > 0
			not check_invalid_coord(coord)
			gamedata.get_generated_ships.count > 0
		local
			tempRow, tempCol: INTEGER
			tempCoord: COORD
			matchedShipSize: INTEGER
		do
			matchedShipSize := 0

			across gamedata.get_generated_ships as ship loop
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

			Result := matchedShipSize

		ensure
			return_positive: Result >= 0

		end

	check_ship_already_hit(coord: COORD): BOOLEAN
		require
			coord.x > 0 and coord.y > 0
			not check_invalid_coord(coord)
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

				--print("%NImple Coord check: [" + ship.row.out + ", " + ship.col.out + "] " + implementation[ship.row.item, ship.col.item].out)

				create coord.make (coord_x, coord_y)

				if check_ship_already_hit(coord) then -- hit
					numOfHit := numOfHit + 1
				end

				-- based on dir, add to coor
				if ship.dir.item then	coord_x := coord_x + 1
				else coord_y := coord_y + 1
				end

			end

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
		require
			coord.x > 0 and coord.y > 0
			not check_invalid_coord(coord)
			gamedata.get_generated_ships.count > 0
		local
			shipSize: INTEGER
			sunk: BOOLEAN
		do
			sunk := False
			shipSize := check_coord_is_hit(coord)

			across gamedata.get_generated_ships as ship loop
				if ship.item.size ~ shipSize then
					sunk := check_ship_sunk(ship.item)
				end
			end

			Result := sunk
		end

	-- if all ships are sunk, win
	check_win: BOOLEAN
		require
			not check_lose
		do
			Result := (gamedata.get_current_ships >= gamedata.get_current_ships_limit)
		end

	-- Assume 'check_win' checked first. So we know all ships are not sunk
	check_lose: BOOLEAN
		require
			not check_win
		do
			Result := (gamedata.get_current_fire >= gamedata.get_current_fire_limit and
						gamedata.get_current_bomb >= gamedata.get_current_bomb_limit)
		end

feature -- query for error
	check_invalid_coord(coord: COORD): BOOLEAN
		do
			--print("%Ncheck_invalid_coord: " + coord.x.out + ", " + coord.y.out + " in " + gamedata.current_board_size.out)
			Result := not (coord.x <= gamedata.get_current_board_size and coord.y <= gamedata.get_current_board_size)
		end

	check_already_fired(coord: COORD): BOOLEAN
		do
			-- See if coord is already 'marked'
			Result := check_ship_already_hit(coord)
		end

	-- This is AFTER executing commad. Checking if it was a hit not miss.
	check_if_it_was_hit(coord: COORD): BOOLEAN
		require
			coord.x > 0 and coord.y > 0
			not check_invalid_coord(coord)
		do
			if implementation[coord.x, coord.y] ~ 'X' then
				Result := True
			elseif implementation[coord.x, coord.y] ~ 'O' then
				Result := False
			else		-- could be 'v' or 'h' or '_'?
				Result := False
			end
		end

	check_fire_happened: BOOLEAN
		do
			Result := (gamedata.get_current_fire > 0 or gamedata.get_current_bomb > 0)
		end


feature -- query for display
	display_value_on_board(coord: COORD): CHARACTER
		require
			coord.x > 0 and coord.y > 0
			not check_invalid_coord(coord)
		do
			Result := implementation[coord.x, coord.y]
		end

feature {ETF_MODEL} -- out

	message_out(stateNum: INTEGER): STRING
		require
			stateNum >= 0
		do
			Result := "  " + message.get_msg_numOfCmd(stateNum) + " " + message.get_msg_error_reference + message.get_msg_error + " -> " + message.get_msg_command
		end

    board_out: STRING
			-- representation of board
		local
			size: INTEGER
		do
			Result := ""
			if started or gameover then

				size := gamedata.get_current_board_size
				Result := Result + "%N     "	-- 5 spaces

				-- Draw Coord (1, 2, 3, 4 ....)
				across 1 |..| size as h loop
					Result := Result + h.item.out
					-- if less than 10, leave 2 spaces. Otherwise, 1 space
					if h.item < size then
						if h.item < 9 then
							Result := Result + "  "
						else
							Result := Result + " "
						end
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
		end

	score_out(current_game: INTEGER; current_total_score: INTEGER; current_total_score_limit: INTEGER): STRING	-- for bottom of board. Scores to display
		local
			i: INTEGER
			coord: COORD
			tempRow,tempCol: INTEGER
		do

			Result := ""
			if started or gameover then

				Result := "%N  "
				-- Current Game
				Result := Result + "Current Game"
				if debugMode then
					Result := Result + " (debug)"
				end
				Result := Result + ": " + current_game.out
				Result := Result + "%N  "
				-- Shots
				Result := Result + "Shots: "
				Result := Result + gamedata.get_current_fire.out + "/" + gamedata.get_current_fire_limit.out
				Result := Result + "%N  "
				-- Bombs
				Result := Result + "Bombs: "
				Result := Result + gamedata.get_current_bomb.out + "/" + gamedata.get_current_bomb_limit.out
				Result := Result + "%N  "
				-- Score
				Result := Result + "Score: "
				Result := Result + gamedata.get_current_score.out + "/" + gamedata.get_current_score_limit.out
				Result := Result + " (Total: " + current_total_score.out + "/" + current_total_score_limit.out + ")"
				Result := Result + "%N  "
				-- Ships
				Result := Result + "Ships: "
				Result := Result + gamedata.get_current_ships.out + "/" + gamedata.get_current_ships_limit.out

				-- Each ships status
				--board.gamedata.test_ships_generated -- just testing

				i := gamedata.get_current_ships_limit
				across gamedata.get_generated_ships as ship loop
					Result := Result + "%N    "
					Result := Result + i.out + "x1: "
					if debugMode then
						-- Loop for size of ship and check for hit
						tempRow := ship.item.row
						tempCol := ship.item.col

						across 1 |..| ship.item.size as j loop

							Result := Result + "[" + gamedata.row_chars[tempRow] + ","
							if tempCol < 10 then
								Result := Result + " "	-- if less than 10, give space
							end
							Result := Result + tempCol.out + "]"
							Result := Result + "->"

							-- Check for Hit
							create coord.make (tempRow, tempCol)
							Result := Result + display_value_on_board(coord).out

							-- Check if last one
							if j.item < ship.item.size then
								Result := Result + ";"
							end

							-- Set for the next one
							if ship.item.dir then
								tempRow := tempRow + 1
							else
								tempCol := tempCol + 1
							end

						end
					else
						if check_ship_sunk(ship.item) then
							Result := Result + "Sunk"
						else
							Result := Result + "Not Sunk"
						end
					end
					i := i - 1
				end


			end

		end


end
