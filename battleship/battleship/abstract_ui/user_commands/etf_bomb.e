note
	description: ""
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
			shipSize1, shipSize2: INTEGER	-- sunken ships size
    	do
    		x1 := coordinate1.row.as_integer_32
			y1 := coordinate1.column.as_integer_32
			x2 := coordinate2.row.as_integer_32
			y2 := coordinate2.column.as_integer_32

			create coord1.make (x1, y1)
			create coord2.make (x2, y2)
			create op.make (coord1, coord2)

			-- Start checking error of new coord before execute
			if not model.board.started then

				model.set_msg_error(model.board.gamedata.err_game_not_started)
				model.set_msg_command (model.board.gamedata.msg_start_new)
			elseif model.board.check_invalid_coord (coord1) or model.board.check_invalid_coord (coord2) then

				model.set_msg_error(model.board.gamedata.err_invalid_coord)
				model.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif check_not_adjacent(coord1, coord2) then

				model.set_msg_error(model.board.gamedata.err_adjacent_coord)
				model.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif model.board.check_already_fired (coord1) or model.board.check_already_fired (coord2) then

				model.set_msg_error(model.board.gamedata.err_already_fired_coord)
				model.set_msg_command (model.board.gamedata.msg_keep_fire)
			elseif check_no_bombs then

				model.set_msg_error(model.board.gamedata.err_no_bomb)
				model.set_msg_command (model.board.gamedata.msg_keep_fire)
			else

				print("%NBOMB OP message BEFORE: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				model.board.history.extend_history (op)
				op.execute


				model.set_msg_error(model.board.gamedata.err_ok)
				model.set_msg_command_from_board	-- get messages from board and display
				-- set messages to 'op' for undo, redo  execute
				op.set_msg_error(model.get_msg_error)
				op.set_msg_command(model.get_msg_command)
				op.set_statenum (model.numberofcommand + 1)
				print("%NBOMB OP message AFTER: ["+ op.get_op_name.out +"] state "+ op.get_stateNum.out + " " + op.get_msg_error.out + " -> " +op.get_msg_command.out)

				-- check if game is over.
				if model.board.gameover then
					-- transfer data to model. Some are done when debig_test or new_game
					model.update_current_total_score
				end

			end


			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
