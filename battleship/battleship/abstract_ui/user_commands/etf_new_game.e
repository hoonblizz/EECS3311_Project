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
	new_game(level_str: INTEGER_64)
		require else
			new_game_precond(level_str)
		local
			op: OPERATION_NEW_GAME
			level_int: INTEGER
			mode: STRING
    	do

			--print("%N===================================")
			--print("%N========== ["+ model.numberOfCommand.out + "] NEW_GAME called ")
			--print("%N===================================")

			-- perform some update on the model state
			-- setup board

			create op.make		-- History is created in make_board

			if not model.board.get_started then
				level_int := level_str.as_integer_32

				-- different mode
				mode := model.board.gamedata.get_game_mode(False, False)
				if model.current_game_mode /~ mode and not (model.current_game_mode ~ "custom_setup") then
					model.init_gen_ship -- reinit random generator if same test is running
				end
				--model.set_game_mode (mode)


				-- level, custom, debug, dimension, ships, max_shots, num_bombs
				model.make_board (level_int, False, False, 0, 0, 0, 0)
				model.board.set_started


				model.board.history.extend_history (op)

				model.start_game_data_setting(level_int, False, False)

				-- clear messages before display
				model.board.message.clear_msg_command

				model.board.message.set_msg_error (model.board.gamedata.err_ok)
				model.board.message.set_msg_command (model.board.gamedata.msg_fire_away)

				-- set messages for history (undo, redo)
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1) -- why +1? because its before 'default_update'
				op.set_implementation		-- copy and paste current changed board

				--print("%N HISTORY AFTER - DEBUG_TEST")
				model.board.history.display_all	-- just for testing

			else

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_game_already_started)
				keepFire_or_fireAway

				model.board.history.extend_history (op)

				-- set messages for history (undo, redo)
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1) -- why +1? because its before 'default_update'


			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
