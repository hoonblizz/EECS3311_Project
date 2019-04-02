note
	description: "Summary description for {OPERATION_FIRE}."
	author: "Taehoon Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	OPERATION_FIRE
inherit
	OPERATION

create
	make

feature {NONE} -- constructor

	make(a_new_position: COORD)
		do
			--old_position := board.coord_fire
			position := a_new_position

			msg_error := board.message.get_msg_error
			msg_command := board.message.get_msg_command
			stateNum := board.get_numberofcommand

			create implementation.make_filled ('_', board.gamedata.get_current_board_size, board.gamedata.get_current_board_size)
			implementation.copy (board.implementation)	-- make copy of board


			-- in ETF_FIRE, values are stored once again BEFORE execute
			old_shots := board.gamedata.get_current_fire
			old_bombs := board.gamedata.get_current_bomb
			old_ships := board.gamedata.get_current_ships
			old_score := board.gamedata.get_current_score
			old_total_score := board.gamedata.get_current_total_score
		end

feature {NONE} -- protect variables for each command
	op_name: STRING = "fire"
	--old_position: COORD
	position: COORD

	msg_error: STRING
	msg_command: STRING
	stateNum: INTEGER

	implementation: ARRAY2[CHARACTER] -- will be a copy of board

	-- also save shots, bombs, ships, score
	old_shots, old_bombs, old_ships, old_score, old_total_score: INTEGER

feature -- query
	set_msg_error(msg: STRING)
		do msg_error := msg end

	set_msg_command(msg: STRING)
		do msg_command := msg end

	set_stateNum(num: INTEGER)
		do stateNum := num end

	set_implementation		-- update board to latest board state
		do
			implementation.copy (board.implementation)

		end

	get_msg_error: STRING
		do Result := msg_error end

	get_msg_command: STRING
		do Result := msg_command end

	get_stateNum: INTEGER
		do Result := stateNum end

	get_op_name: STRING
		do Result := op_name end

	get_implementation: ARRAY2[CHARACTER]
		do Result := implementation end

feature -- commands
	-- At this point, assume all error cases are handled. (in ETF)
	execute
		do

			board.mark_fire (position) -- going to mark 'X' or 'O'

		end

	undo
		do

			-- placed at the end of undo process. Cause we need board AFTER undo
			--board.paste_on_board(implementation)

			-- update for variables
			board.gamedata.update_shots(old_shots)
			board.gamedata.update_bombs(old_bombs)
			board.gamedata.update_ships(old_ships)
			board.gamedata.update_score(old_score)
			board.gamedata.update_total_score(old_total_score)

		end

	redo
		do
			if msg_error ~ board.gamedata.err_ok then
				execute
			end
		end


end
