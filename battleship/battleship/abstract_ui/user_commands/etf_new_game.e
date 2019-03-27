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
	new_game(level_str: INTEGER_64)
		require else
			new_game_precond(level_str)
		local
			level_int: INTEGER
			coord: COORD
			gamedata: GAMEDATA
    	do
    		--create gamedata
			-- perform some update on the model state
			-- setup board

			if not model.board.started then
				level_int := level_str.as_integer_32
				model.make_board (level_int, False)
				model.board.set_started

				-- update current game, total score, total score limit
				-- 	in both 'model', 'model.board.gamedata' level.
				--	so when modificatino happens in 'BOARD',
				--	MODEL receives values from 'BOARD' and copy to itself
				--	Then display its value in MODEL (score_out).

				-- GAMEDATA to MODEL
				model.update_current_game
				model.update_current_total_score_limit
				--model.update_current_total_score -- done when gameover
				-- MODEL to GAMEDATA
				model.board.gamedata.update_current_game(model.board.gamedata.current_game)
				model.board.gamedata.update_current_total_score(model.current_total_score)
				model.board.gamedata.update_current_total_score_limit(model.current_total_score_limit)

				create coord.make (level_int, level_int)
				model.set_msg_error (model.board.gamedata.err_ok)
				model.set_msg_command (model.board.gamedata.msg_fire_away)
			else
				model.set_msg_error(model.board.gamedata.err_game_already_started)

				-- game start command and no fire is made yet => 'Fire Away!'
				--	game start command in middle of battle => 'Keep Firing!'
				if model.board.check_fire_happened then
					model.set_msg_command (model.board.gamedata.msg_keep_fire)
				else
					model.set_msg_command (model.board.gamedata.msg_fire_away)
				end
			end
			--gamedata.make
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
