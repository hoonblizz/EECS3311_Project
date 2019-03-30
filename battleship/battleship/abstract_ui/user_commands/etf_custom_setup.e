note
	description: "Summary description for {ETF_CUSTOM_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_CUSTOM_SETUP
inherit
	ETF_CUSTOM_SETUP_INTERFACE
		redefine custom_setup end
create
	make

feature -- command
	custom_setup(dimension: INTEGER_64; ships: INTEGER_64; max_shots: INTEGER_64; num_bombs: INTEGER_64)
		local
			op: OPERATION_CUSTOM_SETUP
			boardSize, num_ship, num_shot, num_bomb: INTEGER
			mode: STRING
		do

			if not model.board.started then

				boardSize := dimension.as_integer_32
				num_ship := ships.as_integer_32
				num_shot := max_shots.as_integer_32
				num_bomb := num_bombs.as_integer_32

				-- If it's not first time running and different mode
				mode := model.board.gamedata.get_game_mode(True, False)
				if not (model.current_game_mode ~ mode) then
					model.reset_values -- Different mode. Reset model values.
				end
				model.set_game_mode(mode)

				-- level, custom, debug, dimension, ships, max_shots, num_bombs
				model.make_board (0, True, False, boardSize, num_ship, num_shot, num_bomb)
				model.board.set_started

				create op.make		-- History is created in make_board
				model.board.history.extend_history (op)

				model.start_game_data_setting(0, True, False)

				-- clear messages before display
				model.board.message.clear_msg_command

				model.board.message.set_msg_error (model.board.gamedata.err_ok)
				model.board.message.set_msg_command (model.board.gamedata.msg_fire_away)

				-- set messages for history (undo, redo)
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1) -- why +1? because its before 'default_update'

				print("%N HISTORY AFTER - CUSTOM_SETUP")
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
