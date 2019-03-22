note
	description: "Summary description for {COORD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COORD
inherit
	ANY
		redefine out end
	DEBUG_OUTPUT
		redefine out end

create
	make

feature{NONE}
	make(a_x, a_y: INTEGER)
			-- may not be a valid square
		do
			x := a_x
			y := a_y
		end

	board: BOARD
			-- access board via singleton
		local
			ma: ETF_MODEL_ACCESS
		once
			Result := ma.m.board
		end

feature
	x: INTEGER
		-- x position
	y:INTEGER
		-- y position

	valid(a_x,a_y: INTEGER): BOOLEAN
			-- Is this square within the current board?
		local
			l_size: INTEGER
		do
			l_size := board.gamedata.current_board_size
			Result :=
			(1 <= a_x and a_x <= l_size) and (1 <= a_y and  a_y <= l_size)
		end
	debug_output: STRING
		do
			Result := out
		end

	out: STRING
		do
			Result := "[" + x.out + "," + y.out + "]"
		end


end
