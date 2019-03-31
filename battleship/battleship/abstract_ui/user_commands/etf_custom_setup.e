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

feature -- condition check
	check_ships_not_enough(dimension: INTEGER; num_ship: INTEGER): BOOLEAN
		do
			Result := (num_ship < (dimension // 3))

		end
	check_ships_too_many(dimension: INTEGER; num_ship: INTEGER): BOOLEAN
		do
			Result := num_ship > ((dimension // 2) + 1)

		end

	check_shots_not_enough(dimension: INTEGER; num_ship: INTEGER; max_shots: INTEGER): BOOLEAN
		do
			Result := max_shots < (num_ship * (num_ship + 1) // 2)

		end
	check_shots_too_many(dimension: INTEGER; num_ship: INTEGER; max_shots: INTEGER): BOOLEAN
		do
			Result := max_shots > (dimension * dimension)

		end

	check_bombs_not_enough(dimension: INTEGER; num_bombs: INTEGER): BOOLEAN
		do
			Result := num_bombs < (dimension // 3)

		end
	check_bombs_too_many(dimension: INTEGER; num_bombs: INTEGER): BOOLEAN
		do
			Result := num_bombs > ((dimension // 2) + 1)

		end

feature -- command
	custom_setup(dimension: INTEGER_64; ships: INTEGER_64; max_shots: INTEGER_64; num_bombs: INTEGER_64)
		local
			op: OPERATION_CUSTOM_SETUP
			boardSize, num_ship, num_shot, num_bomb: INTEGER
			mode: STRING
		do
			print("%N===================================")
			print("%N========== ["+ model.numberOfCommand.out + "] CUSTOM_SETUP called ")
			print("%N===================================")

			boardSize := dimension.as_integer_32
			num_ship := ships.as_integer_32
			num_shot := max_shots.as_integer_32
			num_bomb := num_bombs.as_integer_32

			if model.board.started then

				create op.make		-- History is created in make_board
				model.board.history.extend_history (op)

				model.board.message.clear_msg_command

				model.board.message.set_msg_error(model.board.gamedata.err_game_already_started)

				keepFire_or_fireAway

				-- set messages for history (undo, redo)
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1) -- why +1? because its before 'default_update'

			elseif check_ships_not_enough(boardSize, num_ship) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_not_enough_ships)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)

			elseif check_ships_too_many(boardSize, num_ship) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_too_many_ships)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)

			elseif check_shots_not_enough(boardSize, num_ship, num_shot) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_not_enough_shots)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)

			elseif check_shots_too_many(boardSize, num_ship, num_shot) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_too_many_shots)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)

			elseif check_bombs_not_enough(boardSize, num_bomb) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_not_enough_bombs)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)

			elseif check_bombs_too_many(boardSize, num_bomb) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_too_many_bombs)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)

			else

				-- different mode
				mode := model.board.gamedata.get_game_mode(True, False)
				if model.current_game_mode /~ mode and not (model.current_game_mode ~ "new_game") then
					model.init_gen_ship -- reinit random generator if same test is running
				end
				--model.set_game_mode (mode)


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


			end

			print("%N HISTORY AFTER - CUSTOM_SETUP")
			model.board.history.display_all	-- just for testing


			model.default_update
			etf_cmd_container.on_change.notify ([Current])
		end

end
