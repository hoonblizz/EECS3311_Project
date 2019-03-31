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

feature --message
	keepFire_or_fireAway
		do
			-- game start command and no fire is made yet => 'Fire Away!'
			--	game start command in middle of battle => 'Keep Firing!'
			if model.board.check_fire_happened then
				model.board.message.set_msg_command (model.board.gamedata.msg_keep_fire)
			else
				model.board.message.set_msg_command (model.board.gamedata.msg_fire_away)
			end
		end


feature -- command
	debug_test(level_str: INTEGER_64)
		require else
			debug_test_precond(level_str)
		local
			op: OPERATION_DEBUG_TEST
			level_int: INTEGER
			mode: STRING
    	do
    		print("%N===================================")
			print("%N========== ["+ model.numberOfCommand.out + "] DEBUG_TEST called ")
			print("%N===================================")

			-- perform some update on the model state
			if not model.board.started then
				level_int := level_str.as_integer_32

				-- different mode
				mode := model.board.gamedata.get_game_mode(False, True)
				if model.current_game_mode /~ mode and not (model.current_game_mode ~ "custom_setup_test") then
					model.init_gen_ship -- reinit random generator if same test is running
				end
				--model.set_game_mode (mode)

				-- level, custom, debug, dimension, ships, max_shots, num_bombs
				model.make_board (level_int, False, True, 0, 0, 0, 0)
				model.board.set_started

				create op.make		-- History is created in make_board
				model.board.history.extend_history (op)

				model.start_game_data_setting(level_int, False, True)

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


				keepFire_or_fireAway

			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
