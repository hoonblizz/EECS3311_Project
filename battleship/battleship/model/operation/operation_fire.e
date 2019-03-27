note
	description: "Summary description for {OPERATION_FIRE}."
	author: ""
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
			old_position := board.coord_fire
			position := a_new_position
			old_msg_error := model.get_msg_error
			old_msg_command := model.get_msg_command
			old_stateNum := model.numberofcommand
			msg_error := model.get_msg_error
			msg_command := model.get_msg_command
			stateNum := model.numberofcommand

			print("%NOP_FIRE make: state "+ old_stateNum.out + " " + old_msg_error.out + " -> " + old_msg_command.out)

			-- in ETF_FIRE, values are stored once again BEFORE execute
			old_shots := board.gamedata.current_fire
			old_bombs := board.gamedata.current_bomb
			old_ships := board.gamedata.current_ships
			old_score := board.gamedata.current_score
		end

feature
	op_name: STRING = "fire"
	old_position: COORD
	position: COORD

	old_msg_error: STRING
	old_msg_command: STRING
	old_stateNum: INTEGER
	msg_error: STRING
	msg_command: STRING
	stateNum: INTEGER

	old_implementation: CHARACTER	--save what the symbol was ( '_', 'v', 'h')
	new_implementation: CHARACTER

	-- also save shots, bombs, ships, score
	old_shots, old_bombs, old_ships, old_score: INTEGER

feature -- query
	set_msg_error(msg: STRING)
		do msg_error := msg end

	set_msg_command(msg: STRING)
		do msg_command := msg end

	set_stateNum(num: INTEGER)
		do stateNum := num end

	get_old_msg_error: STRING
		do Result := old_msg_error end

	get_old_msg_command: STRING
		do Result := old_msg_command end

	get_old_stateNum: INTEGER
		do Result := old_stateNum end

	get_msg_error: STRING
		do Result := msg_error end

	get_msg_command: STRING
		do Result := msg_command end

	get_stateNum: INTEGER
		do Result := stateNum end

	get_op_name: STRING
		do Result := op_name end


feature -- commands
	-- At this point, assume all error cases are handled. (in ETF)
	execute
		do
			old_implementation := board.implementation[position.x, position.y]
			board.mark_fire (position) -- going to mark 'X' or 'O'
			new_implementation := board.implementation[position.x, position.y]
		end

	undo
		do
			board.mark_empty(position, old_implementation)

			-- update for variables
			board.gamedata.update_shots(old_shots)
			board.gamedata.update_bombs(old_bombs)
			board.gamedata.update_ships(old_ships)
			board.gamedata.update_score(old_score)

		end

	redo
		do
			-- To Do
			execute
		end


end
