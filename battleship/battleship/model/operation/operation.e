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

feature -- check errors

	check_invalid_coord(coord: COORD): BOOLEAN
		do

		end

	check_already_fired(coord: COORD): BOOLEAN
		do

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
