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
			boardSize, num_ship, num_shot, num_bomb: INTEGER
		do

			if not model.board.started then
				boardSize := dimension.as_integer_32
				num_ship := ships.as_integer_32
				num_shot := max_shots.as_integer_32
				num_bomb := num_bombs.as_integer_32

				

			else
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
