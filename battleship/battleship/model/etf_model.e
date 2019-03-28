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
			numberOfCommand_ref := 0		-- only for undo,redo

			current_game := 0
			current_total_score := 0
			current_total_score_limit := 0
			message := ""
			msg_error := board.gamedata.err_ok
			msg_command := <<board.gamedata.msg_start_new>>

			msg_error_reference := ""	-- in general, it'm empty. But in undo, redo
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

feature -- message
	-- Message has a form of
	-- number of command(integer), status(OK) or error, command status(could be more than 1)
	-- ex) state 1 OK -> Fire Away!
	-- ex) state 11 Game already started -> Keep Firing!
	-- ex) state 9 OK -> 4x1 and 3x1 ships sunk! Keep Firing!
	-- ex) state 12 OK -> 2x1 ship sunk! Keep Firing!

	message: STRING
	msg_error: STRING
	msg_error_reference: STRING	-- only for undo, redo cases
	msg_command: ARRAY[STRING	]

	set_msg_error(a_message: STRING)
		do
			msg_error := a_message
		end
	set_msg_error_reference(a_message: STRING)
		do
			msg_error_reference := a_message
		end

	-- In ETF_FIRE, for error cases, directly call 'set_msg_command'
	--	but for commands in board, call 'set_msg_command_from_board' to get messages
	set_msg_command(a_message: STRING)
		do
			msg_command.force(a_message, msg_command.count + 1)
		end
	set_msg_command_from_board
		do
			clear_msg_command -- clear before stack messages from BOARD
			across board.msg_command as msg loop
				set_msg_command(msg.item)
			end
		end

	get_msg_numOfCmd: STRING
		do
			Result := "state " + numberOfCommand.out
		end

	get_msg_error: STRING
		do
			Result := msg_error
		end
	get_msg_error_reference: STRING		-- only for undo, redo
		do
			Result := msg_error_reference
		end

	get_msg_command: STRING
		local
			temp: STRING
			i: INTEGER
		do
			create temp.make_empty
			from i := 1
			until i > msg_command.count
			loop
				temp := temp + msg_command[i]
				if i < msg_command.count then
					temp := temp + " " -- have a space between except the last one
				end
				i := i + 1
			end
			Result := temp
		end

	clear_msg_command
		do
			msg_command.make_empty
		end

	clear_msg_error_reference
		do msg_error_reference := "" end

feature -- model attributes
	numberOfCommand : INTEGER
	-- just for undo, redo. Check OPERATION_FIRE
	--		only update (set same as numberOfCommand)
	--	 	when history.extend happened. (when this happens, all rights are removed)
	--		
	numberOfCommand_ref: INTEGER

	-- These values don't change when new game started.
	current_game: INTEGER -- number of game currently running
	current_total_score, current_total_score_limit: INTEGER


feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			numberOfCommand := numberOfCommand + 1
		end
	update_stateNum_ref(val: INTEGER)		-- only for undo,redo message
		do
			numberOfCommand_ref := val
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

			create Result.make_from_string ("  " + get_msg_numOfCmd + " " + msg_error_reference + get_msg_error + " -> " + get_msg_command + "%N")

			-- clear command message when error is OK.
			--if get_msg_error ~ board.gamedata.err_ok then
				--clear_msg_command
				--board.clear_msg_command
			--end

			Result.append (board.out)
			Result := Result + score_out
		end

end




