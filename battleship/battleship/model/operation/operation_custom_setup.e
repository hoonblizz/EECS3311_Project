note
	description: "Summary description for {OPERATION_CUSTOM_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OPERATION_CUSTOM_SETUP

inherit
	OPERATION

create
	make

feature {NONE} -- constructor

	make
		do

			msg_error := board.message.get_msg_error
			msg_command := board.message.get_msg_command
			stateNum := board.numberofcommand

			print("%NCUSTOM_SETUP OP make: state "+ stateNum.out + " " + msg_error.out + " -> " + msg_command.out)

			-- in ETF_FIRE, values are stored once again BEFORE execute
			old_shots := board.gamedata.current_fire
			old_bombs := board.gamedata.current_bomb
			old_ships := board.gamedata.current_ships
			old_score := board.gamedata.current_score
			old_total_score := board.gamedata.current_total_score

		end

feature
	op_name: STRING = "custom_setup"

	msg_error: STRING
	msg_command: STRING
	stateNum: INTEGER

	-- also save shots, bombs, ships, score
	old_shots, old_bombs, old_ships, old_score, old_total_score: INTEGER

feature -- query
	set_msg_error(msg: STRING)
		do msg_error := msg end

	set_msg_command(msg: STRING)
		do msg_command := msg end

	set_stateNum(num: INTEGER)
		do stateNum := num end

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

		end

	undo
		do

		end

	redo
		do

		end


end


