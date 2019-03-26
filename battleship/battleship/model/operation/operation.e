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
