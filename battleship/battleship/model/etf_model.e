note
	description: "[A default business model.]"
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			make_board (4, False)
			numberOfCommand := 0

			current_game := 0
			current_total_score := 0
			current_total_score_limit := 0

		end

feature -- board

    make_board(level: INTEGER; debug_mode: BOOLEAN)
    	-- 13, 14, 15, 16 (easy, medium, hard, advanced)
    	--require
    	--	12 < level and level < 17
    	do
    		create board.make(level, debug_mode)
    	end

    board: BOARD

feature -- model attributes
	numberOfCommand : INTEGER

	-- These values don't change when new game started.
	current_game: INTEGER -- number of game currently running
	current_total_score, current_total_score_limit: INTEGER


feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			numberOfCommand := numberOfCommand + 1
			--board.update_statenum (numberOfCommand) -- for OPERATION_FIRE

			if board.numberofcommand_ref ~ 0 then
				--board.update_statenum_ref (numberOfCommand)
			end
		end

	-- these updates are from 'BOARD.GAMEDATA' to 'MODEL'
	--		See BOARD for comparison
	update_current_game		-- only updated when debug_test or new_game
		do
			current_game := current_game + 1
		end

	update_current_total_score	-- for realtime update in score_out.
		do
			current_total_score := board.gamedata.current_total_score
		end

	update_current_total_score_limit
		do
			current_total_score_limit := current_total_score_limit + board.gamedata.current_score_limit
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries

	score_out: STRING	-- for bottom of board. Scores to display
		local
			i: INTEGER
			sunk: BOOLEAN
			coord: COORD
			tempRow,tempCol: INTEGER
		do

			update_current_total_score	-- update total_score. GAMEDATA -> MODEL

			Result := ""
			if board.started or board.gameover then
				Result := "%N  "
				-- Current Game
				Result := Result + "Current Game"
				if board.debugMode then
					Result := Result + " (debug)"
				end
				Result := Result + ": " + current_game.out
				Result := Result + "%N  "
				-- Shots
				Result := Result + "Shots: "
				Result := Result + board.gamedata.current_fire.out + "/" + board.gamedata.current_fire_limit.out
				Result := Result + "%N  "
				-- Bombs
				Result := Result + "Bombs: "
				Result := Result + board.gamedata.current_bomb.out + "/" + board.gamedata.current_bomb_limit.out
				Result := Result + "%N  "
				-- Score
				Result := Result + "Score: "
				Result := Result + board.gamedata.current_score.out + "/" + board.gamedata.current_score_limit.out
				Result := Result + " (Total: " + current_total_score.out + "/" + current_total_score_limit.out + ")"
				Result := Result + "%N  "
				-- Ships
				Result := Result + "Ships: "
				Result := Result + board.gamedata.current_ships.out + "/" + board.gamedata.current_ships_limit.out

				-- Each ships status
				--board.gamedata.test_ships_generated -- just testing

				i := board.gamedata.current_ships_limit
				across board.gamedata.generated_ships as ship loop
					Result := Result + "%N    "
					Result := Result + i.out + "x1: "
					if board.debugMode then
						-- Loop for size of ship and check for hit
						tempRow := ship.item.row
						tempCol := ship.item.col

						across 1 |..| ship.item.size as j loop

							Result := Result + "[" + board.gamedata.row_chars[tempRow] + ", " + tempCol.out + "]"
							Result := Result + "->"

							-- Check for Hit
							create coord.make (tempRow, tempCol)
							Result := Result + board.display_value_on_board(coord).out

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
						if board.check_ship_sunk(ship.item) then
							Result := Result + "Sunk"
						else
							Result := Result + "Not Sunk"
						end
					end
					i := i - 1
				end


			end

		end

	out : STRING
		do

			create Result.make_from_string ("  " + board.message.get_msg_numOfCmd(numberOfCommand) + " " + board.message.msg_error_reference + board.message.get_msg_error + " -> " + board.message.get_msg_command + "%N")

			-- clear command message when error is OK.
			--if get_msg_error ~ board.gamedata.err_ok then
				--clear_msg_command
				--board.clear_msg_command
			--end

			Result.append (board.out)
			Result := Result + score_out
		end

end




