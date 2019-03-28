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

feature -- query

	check_no_shots: BOOLEAN
		do
			Result := (model.board.gamedata.current_fire >= model.board.gamedata.current_fire_limit)
		end

feature -- command

	fire(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			fire_precond(coordinate)
		local
			op: OPERATION_FIRE
			l_x,l_y: INTEGER
			coord: COORD
			shipSize: INTEGER
    	do
			l_x := coordinate.row.as_integer_32
			l_y := coordinate.column.as_integer_32

			create coord.make (l_x, l_y)
			create op.make (coord)

			-- Start checking error of new coord before execute
			if not model.board.started then

				model.set_msg_error(model.board.gamedata.err_game_not_started)
				model.set_msg_command (model.board.gamedata.msg_start_new)
			elseif model.board.check_invalid_coord (coord) then

				model.set_msg_error(model.board.gamedata.err_invalid_coord)
				model.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif model.board.check_already_fired (coord) then

				model.set_msg_error(model.board.gamedata.err_already_fired_coord)
				model.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif check_no_shots then

				model.set_msg_error(model.board.gamedata.err_no_shots)
				model.set_msg_command (model.board.gamedata.msg_keep_fire)
			else

				model.clear_msg_error_reference		-- clear '(= stateX)' message

				print("%NFIRE OP message BEFORE: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				model.board.history.extend_history (op)
				op.execute

				model.update_stateNum_ref(model.numberofcommand + 1)	-- set number that will be assigned after all code

				model.set_msg_error(model.board.gamedata.err_ok)
				model.set_msg_command_from_board	-- get messages from board and display
				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.get_msg_error)
				op.set_msg_command(model.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)

				print("%NFIRE OP message AFTER: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				-- check if game is over.
				if model.board.gameover then
					-- transfer data to model. Some are done when debig_test or new_game
					model.update_current_total_score
					model.board.history.remove_all	-- clear all history to stop undo redo
				end

				model.board.history.display_all	-- just for testing


			end




			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
