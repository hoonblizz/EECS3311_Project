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
		end

feature
	old_position: COORD
	position: COORD

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
