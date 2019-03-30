note
	description: "Summary description for {OPERATION_BOMB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OPERATION_BOMB

inherit
	OPERATION

create
	make

feature {NONE} -- constructor

	make(new_pos1: COORD; new_pos2: COORD)
		do

			position1 := new_pos1
			position2 := new_pos2

			msg_error := board.message.get_msg_error
			msg_command := board.message.get_msg_command
			stateNum := board.numberofcommand

			create implementation.make (board.gamedata.current_board_size, board.gamedata.current_board_size)
			implementation.copy(board.implementation)	-- make copy of board

			print("%NBOMB OP make: state "+ stateNum.out + " " + msg_error.out + " -> " + msg_command.out)

			print("%NCheck copied OP board...%N")
			across implementation as el loop
				print(el.item.out + " ")
			end

			-- in ETF_FIRE, values are stored once again BEFORE execute
			old_shots := board.gamedata.current_fire
			old_bombs := board.gamedata.current_bomb
			old_ships := board.gamedata.current_ships
			old_score := board.gamedata.current_score
			old_total_score := board.gamedata.current_total_score
		end

feature
	op_name: STRING = "bomb"

	position1: COORD
	position2: COORD

	msg_error: STRING
	msg_command: STRING
	stateNum: INTEGER

	implementation: ARRAY2[CHARACTER] -- will be a copy of board
	old_implementation1: CHARACTER	--save what the symbol was ( '_', 'v', 'h')
	old_implementation2: CHARACTER
	new_implementation1: CHARACTER
	new_implementation2: CHARACTER

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
		do implementation.copy (board.implementation) end

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
			old_implementation1 := board.implementation[position1.x, position1.y]
			old_implementation2 := board.implementation[position2.x, position2.y]
			board.mark_bomb (position1, position2) -- going to mark 'X' or 'O'
			new_implementation1 := board.implementation[position1.x, position1.y]
			new_implementation2 := board.implementation[position2.x, position2.y]
		end

	undo
		do

			-- undo execution only be done when error is OK.
			-- Just need message to display
			if op_name ~ board.gamedata.err_ok then
				--board.mark_empty(position1, old_implementation1)
				--board.mark_empty(position2, old_implementation2)

			else

			end

			--board.paste_on_board(implementation) -- moved to end of undo process

			-- update for variables
			-- for errors, values are the same anyway..so doesn't matter?
			board.gamedata.update_shots(old_shots)
			board.gamedata.update_bombs(old_bombs)
			board.gamedata.update_ships(old_ships)
			board.gamedata.update_score(old_score)
			board.gamedata.update_total_score(old_total_score)

		end

	redo
		do
			-- To Do
			execute
		end



end
