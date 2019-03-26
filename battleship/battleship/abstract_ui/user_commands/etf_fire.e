note
	description: ""
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

			print("%NFire this Coord: " + l_x.out + ", " +l_y.out)
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

				model.board.history.extend_history (op)
				op.execute

				model.set_msg_error(model.board.gamedata.err_ok)

				-- Message is based on whether it's hit or not.
				-- Check if it was a hit
				model.board.gamedata.add_shot  -- add for shot

				if model.board.check_if_it_was_hit(coord) then

					model.board.gamedata.add_score	-- add for hit score

					if model.board.check_hit_caused_sink(coord) then
						-- Ship is sunk. Need Size of ship to display

						model.board.gamedata.add_ship -- add for ship sunk

						shipSize := model.board.check_coord_is_hit (coord)
						model.set_msg_command(model.board.gamedata.msg_ship_sunk(shipSize))
						model.set_msg_command (model.board.gamedata.msg_keep_fire)
					else
						model.set_msg_command(model.board.gamedata.msg_hit)
						model.set_msg_command (model.board.gamedata.msg_keep_fire)
					end
				else
					model.set_msg_command(model.board.gamedata.msg_miss)
					model.set_msg_command (model.board.gamedata.msg_keep_fire)
				end

			end




			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
