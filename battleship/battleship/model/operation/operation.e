note
	description: "Summary description for {OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATION

feature{NONE}

	board: BOARD
			-- access board via singleton
		local
			ma: ETF_MODEL_ACCESS
		once
			Result := ma.m.board
		end
	model : ETF_MODEL
		local
			ma: ETF_MODEL_ACCESS
		once
			Result := ma.m
		end

feature -- deferred query
	get_msg_error: STRING
		deferred end

	get_msg_command: STRING
		deferred end

	get_stateNum: INTEGER
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
