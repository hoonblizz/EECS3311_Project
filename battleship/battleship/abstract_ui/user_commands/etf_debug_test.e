note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DEBUG_TEST
inherit
	ETF_DEBUG_TEST_INTERFACE
		redefine debug_test end
create
	make
feature -- command
	debug_test(level_str: INTEGER_64)
		require else
			debug_test_precond(level_str)
		local
			level_int: INTEGER
			coord: COORD
			gamedata: GAMEDATA
    	do
			-- perform some update on the model state
			if not model.board.started then
				level_int := level_str.as_integer_32
				--model.board.set_debugmode -- Set Debug Before Make board!!!
				model.make_board (level_int, True)
				model.board.set_started
				model.update_current_game
				model.update_current_total_score_limit(level_int)

				create coord.make (level_int, level_int)
				model.set_msg_error (model.board.gamedata.err_ok)
				model.set_msg_command (model.board.gamedata.msg_fire_away)
			else
				model.set_msg_error(model.board.gamedata.err_game_already_started)
				model.set_msg_command (model.board.gamedata.msg_fire_away)
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
