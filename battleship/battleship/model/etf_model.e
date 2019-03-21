note
	description: "[A default business model.]"
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			make_board (4)
			i := 0
			message := "ETF_MODEL default message"
		end

feature -- board

    make_board(a_size:INTEGER)
    	require
    		5 <= a_size and a_size <= 8
    	do
    		create board.make (a_size)
    	end

feature -- message
	message: STRING

	set_message(a_message: STRING)
		do
			message := a_message
		end

feature -- model attributes
	board: BOARD
	i : INTEGER

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  " + message + ":")
			--create Result.make_from_string ("  ")
			--Result.append ("System State: default model state ")
			--Result.append ("(")
			--Result.append (i.out)
			--Result.append (")")

			Result.append (board.out)
		end

end




