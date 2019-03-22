note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_GAME
inherit
	ETF_NEW_GAME_INTERFACE
		redefine new_game end
create
	make
feature -- command
	new_game(level: INTEGER_64)
		require else
			new_game_precond(level)
		local
			level32: INTEGER
			coord: COORD
    	do
			-- perform some update on the model state
			-- setup board
			if not model.board.started then
				level32 := level.as_integer_32
				model.make_board (level32)
				model.board.set_started
				model.update_current_game
				model.update_current_total_score_limit(level32)

				create coord.make (level32, level32)
				model.set_message ("ok")
			else
				model.set_message("game already started")
			end
			--gamedata.make
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
