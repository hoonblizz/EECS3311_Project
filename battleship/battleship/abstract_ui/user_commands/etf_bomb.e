note
	description: "[
	For ETF_BOMB, clearing message is done in mark_bomb (right BEFORE execution command)in BOARD
	and 'set_msg_command_from_board' in MODEL which is used in
	ETF_BOMB AFTER execution.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_BOMB
inherit
	ETF_BOMB_INTERFACE
		redefine bomb end
create
	make

feature -- query

	check_no_bombs: BOOLEAN
		do
			Result := (model.board.gamedata.current_bomb >= model.board.gamedata.current_bomb_limit)
		end

	check_not_adjacent(coord1: COORD; coord2: COORD): BOOLEAN
		local
			xDiff, yDiff: INTEGER
		do

			xDiff := coord1.x - coord2.x
			xDiff := xDiff * xDiff	-- making it positive
			yDiff := coord1.y - coord2.y
			yDiff := yDiff * yDiff

			if (xDiff ~ 1 and yDiff ~ 0) or (yDiff ~ 1 and xDiff ~ 0) then
				Result := False
			else
				Result := True
			end

		end


feature -- command

	bomb(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64] ; coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			bomb_precond(coordinate1, coordinate2)
		local
			op: OPERATION_BOMB
			x1,y1,x2,y2: INTEGER
			coord1, coord2: COORD
    	do

    		x1 := coordinate1.row.as_integer_32
			y1 := coordinate1.column.as_integer_32
			x2 := coordinate2.row.as_integer_32
			y2 := coordinate2.column.as_integer_32

			create coord1.make (x1, y1)
			create coord2.make (x2, y2)


			-- Start checking error of new coord before execute
			if not model.board.started then
				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_game_not_started)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)
			elseif model.board.check_invalid_coord (coord1) or model.board.check_invalid_coord (coord2) then
				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_invalid_coord)
				model.board.message.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif check_not_adjacent(coord1, coord2) then
				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_adjacent_coord)
				model.board.message.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif model.board.check_already_fired (coord1) or model.board.check_already_fired (coord2) then
				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_already_fired_coord)
				model.board.message.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif check_no_bombs then
				model.board.message.clear_msg_command
				model.board.message.set_msg_error(model.board.gamedata.err_no_bomb)
				model.board.message.set_msg_command (model.board.gamedata.msg_keep_fire)
			else

				model.board.update_statenum (model.numberOfCommand)

				create op.make (coord1, coord2)

				model.board.message.clear_msg_error_reference		-- clear '(= stateX)' message

				print("%NBOMB OP message BEFORE: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				model.board.history.extend_history (op)
				op.execute

				--model.board.update_stateNum_ref(model.numberofcommand + 1)	-- set number that will be assigned after all code
				--op.set_old_stateNum(model.numberofcommand)

				model.board.message.set_msg_error(model.board.gamedata.err_ok)

				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.board.message.get_msg_error)
				op.set_msg_command(model.board.message.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)	-- for redo
				print("%NBOMB OP message AFTER: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				-- check if game is over.
				if model.board.gameover then
					-- transfer data to model. Some are done when debig_test or new_game
					model.update_current_total_score
					model.board.history.remove_all	-- clear all history to stop undo redo
					model.update_prev_score
				end

				print("%N HISTORY AFTER - BOMB")
				model.board.history.display_all	-- just for testing


			end


			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
