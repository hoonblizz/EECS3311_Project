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
			op: OPERATION_DEBUG_TEST
			level_int: INTEGER
			coord: COORD
			mode: STRING
    	do

			-- perform some update on the model state
			if not model.board.started then
				level_int := level_str.as_integer_32

				-- If it's not first time running and different mode
				mode := model.board.gamedata.get_game_mode(False, True)
				if model.current_game > 1 and not (model.current_game_mode ~ mode) then
					model.reset_values -- Different mode. Reset model values.
				end
				model.set_game_mode(mode)

				model.make_board (level_int, True)
				model.board.set_started

				create op.make		-- History is created in make_board
				model.board.history.extend_history (op)


				-- update current game, total score, total score limit
				-- 	in both 'model', 'model.board.gamedata' level.
				--	so when modificatino happens in 'BOARD.GAMEDATA',
				--	In MODEL, before update score texts,
				-- 	update new values from board.gamedata then display its value in MODEL (score_out).

				-- GAMEDATA to MODEL
				model.update_current_game
				model.update_current_total_score_limit
				--model.update_current_total_score -- done when gameover

				-- MODEL to GAMEDATA
				model.board.gamedata.update_current_game(model.board.gamedata.current_game)
				model.board.gamedata.update_current_total_score(model.current_total_score)
				model.board.gamedata.update_current_total_score_limit(model.current_total_score_limit)


				create coord.make (level_int, level_int)

				-- clear messages before display
				model.board.message.clear_msg_command

				model.board.message.set_msg_error (model.board.gamedata.err_ok)
				model.board.message.set_msg_command (model.board.gamedata.msg_fire_away)

				-- set messages for history (undo, redo)
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1) -- why +1? because its before 'default_update'

				print("%N HISTORY AFTER - DEBUG_TEST")
				model.board.history.display_all	-- just for testing

			else

				model.board.message.clear_msg_command

				model.board.message.set_msg_error(model.board.gamedata.err_game_already_started)

				-- game start command and no fire is made yet => 'Fire Away!'
				--	game start command in middle of battle => 'Keep Firing!'
				if model.board.check_fire_happened then
					model.board.message.set_msg_command (model.board.gamedata.msg_keep_fire)
				else
					model.board.message.set_msg_command (model.board.gamedata.msg_fire_away)
				end

			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
