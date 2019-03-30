note
	description: "Summary description for {OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATION

feature {NONE}

	board: BOARD
			-- Don't need singleton. We need this to be updated
			--	because when game is over, and create a new game,
			--	if this is singleton, it doesn't update
		local
			ma: ETF_MODEL_ACCESS
		do --once
			Result := ma.m.board
		end

feature -- deferred query

	get_msg_error: STRING
		deferred end

	get_msg_command: STRING
		deferred end

	get_stateNum: INTEGER
		deferred end

	get_op_name: STRING
		deferred end

	get_implementation: ARRAY2[CHARACTER]
		deferred end

feature -- deferred commands
	execute
		deferred
		end
	undo
		deferred
		end

	redo
		deferred
		end

end
