note
	description: "Summary description for {ETF_GIVE_UP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_GIVE_UP
inherit
	ETF_GIVE_UP_INTERFACE
		redefine give_up end

create
	make

feature -- command
	give_up
		do

			if not model.board.started then

				-- clear all previous messages
				model.clear_msg_command
				model.board.clear_msg_command
				
				model.set_msg_error(model.board.gamedata.err_game_not_started)
				model.set_msg_command (model.board.gamedata.msg_start_new)
			else
				model.board.set_gameover

				-- clear all previous messages
				model.clear_msg_command
				model.board.clear_msg_command

				model.set_msg_error(model.board.gamedata.err_ok)
				model.set_msg_command (model.board.gamedata.err_gave_up)

				-- check if game is over.
				if model.board.gameover then
					-- transfer data to model. Some are done when debig_test or new_game
					model.update_current_total_score
					model.board.history.remove_all	-- clear all history to stop undo redo
				end
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
		end

end
