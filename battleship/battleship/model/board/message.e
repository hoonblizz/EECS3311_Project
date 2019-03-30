note
	description: "[
		-- Message has a form of
		-- number of command(integer), status(OK) or error, command status(could be more than 1)
		-- ex) state 1 OK -> Fire Away!
		-- ex) state 11 Game already started -> Keep Firing!
		-- ex) state 9 OK -> 4x1 and 3x1 ships sunk! Keep Firing!
		-- ex) state 12 OK -> 2x1 ship sunk! Keep Firing!
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE
create
	make

feature
	make(level: INTEGER; debug_mode: BOOLEAN)
		local
			gamedata: GAMEDATA
		do
			create gamedata.make (level, False, debug_mode, 0, 0, 0, 0)
			create msg_command.make_empty
			msg_error := gamedata.err_ok
			msg_command := <<gamedata.msg_start_new>>
			msg_error_reference := ""	-- in general, it'm empty. But in undo, redo

			-- For undo. If no item after back, display this.
			--		default_msg_stateNum should be updated when new game starts
			default_msg_stateNum := 1
			default_msg_error := gamedata.err_ok
			default_msg_command := gamedata.msg_start_new
		end

feature

	default_msg_stateNum: INTEGER
	default_msg_error: STRING
	default_msg_command: STRING

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

	set_default_msg(stateNum: INTEGER; err: STRING; cmd: STRING) -- in new_game, debug_test
		do
			default_msg_stateNum := stateNum
			default_msg_error := err
			default_msg_command := cmd
		end

	get_msg_numOfCmd(numOfCmd: INTEGER): STRING
		do
			Result := "state " + numOfCmd.out
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

end
