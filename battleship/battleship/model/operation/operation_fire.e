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
			msg_error := model.get_msg_error
			msg_command := model.get_msg_command
			stateNum := model.numberofcommand
		end

feature
	old_position: COORD
	position: COORD
	msg_error: STRING
	msg_command: STRING
	stateNum: INTEGER

feature -- query
	set_msg_error(msg: STRING)
		do msg_error := msg end
	set_msg_command(msg: STRING)
		do msg_command := msg end

	get_msg_error: STRING
		do Result := msg_error end

	get_msg_command: STRING
		do Result := msg_command end

	get_stateNum: INTEGER
		do Result := stateNum end

feature -- commands
	-- At this point, assume all error cases are handled. (in ETF)
	execute
		do
			board.mark_fire (position) -- going to mark 'X' or 'O'
		end

	undo
		do
			board.mark_empty(position)
			--board.move_king(old_position)
		end

	redo
		do
			-- To Do
			execute
		end


end
