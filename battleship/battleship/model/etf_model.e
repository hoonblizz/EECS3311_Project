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
			current_game := 0
			current_total_score := 0
			current_total_score_limit := 0
			message := "ETF_MODEL default message"
		end

feature -- board

    make_board(level: INTEGER)
    	-- 13, 14, 15, 16 (easy, medium, hard, advanced)
    	require
    		13 >= level and level <= 16
    	do
    		create board.make(level)
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

	-- These values don't change when new game started.
	current_game: INTEGER -- number of game currently running
	current_total_score, current_total_score_limit: INTEGER


feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	update_current_game
		do
			current_game := current_game + 1
		end

	update_current_total_score_limit(level: INTEGER)
		local
			gamedata: GAMEDATA
		do
			create gamedata.make (level)
			current_total_score_limit := current_total_score_limit + gamedata.get_score_limit(level)
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




