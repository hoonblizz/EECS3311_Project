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
			old_position1 := board.coord_bomb1
			old_position2 := board.coord_bomb2
			position1 := new_pos1
			position2 := new_pos2
		end

feature
	-- bomb coord 1, 2
	old_position1: COORD
	old_position2: COORD
	position1: COORD
	position2: COORD

feature -- commands
	-- At this point, assume all error cases are handled. (in ETF)
	execute
		do
			board.mark_bomb (position1, position2) -- going to mark 'X' or 'O'
		end

	undo
		do
			board.mark_empty(position1)
			board.mark_empty(position2)

		end

	redo
		do
			-- To Do
			execute
		end



end
