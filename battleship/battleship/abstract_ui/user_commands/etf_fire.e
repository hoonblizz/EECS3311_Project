note
	description: "[
	For ETF_FIRE, clearing message is done in mark_fire (right BEFORE execution command)in BOARD
	and 'set_msg_command_from_board' in MODEL which is used in
	ETF_FIRE AFTER execution.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
		redefine fire end
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

feature -- query

	check_no_shots: BOOLEAN
		do
			Result := (model.board.gamedata.get_current_fire >= model.board.gamedata.get_current_fire_limit)
		end

feature -- command

	fire(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			fire_precond(coordinate)
		local
			op: OPERATION_FIRE
			l_x,l_y: INTEGER
			coord: COORD
    	do
			--print("%N===================================")
			--print("%N========== ["+ model.numberOfCommand.out + "] FIRE called ")
			--print("%N===================================")

			l_x := coordinate.row.as_integer_32
			l_y := coordinate.column.as_integer_32

			create coord.make (l_x, l_y)

			model.board.update_statenum (model.numberOfCommand)

			create op.make (coord)

			model.board.message.clear_msg_error_reference		-- clear '(= stateX)' message

			-- Start checking error of new coord before execute
			if not model.board.get_started then
				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_game_not_started)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)

				model.board.history.extend_history (op)

				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)	-- for redo

			elseif model.board.check_invalid_coord (coord) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_invalid_coord)
				keepFire_or_fireAway

				model.board.history.extend_history (op)

				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)	-- for redo

			elseif model.board.check_already_fired (coord) then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_already_fired_coord)
				keepFire_or_fireAway

				model.board.history.extend_history (op)

				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)	-- for redo

			elseif check_no_shots then

				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_no_shots)
				keepFire_or_fireAway

				model.board.history.extend_history (op)

				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)	-- for redo

			else

				--model.board.message.clear_msg_error_reference		-- clear '(= stateX)' message

				--print("%NFIRE OP message BEFORE: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				model.board.history.extend_history (op)
				op.execute


				model.board.message.set_msg_error(model.board.gamedata.err_ok)

				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)

				op.set_implementation		-- copy and paste current changed board

				--print("%NFIRE OP message AFTER: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				-- check if game is over.
				if model.board.get_gameover then
					-- transfer data to model. Some are done when debig_test or new_game
					model.update_current_total_score
					model.board.history.remove_all	-- clear all history to stop undo redo
					model.update_prev_score
				end



			end


			--print("%N HISTORY AFTER - FIRE")
			--model.board.history.display_all	-- just for testing


			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
