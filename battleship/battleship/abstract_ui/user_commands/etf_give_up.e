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

			print("%N===================================")
			print("%N========== ["+ model.numberOfCommand.out + "] GIVE_UP called ")
			print("%N===================================")

			if not model.board.get_started then

				-- clear all previous messages
				model.board.message.clear_msg_command

				model.board.message.set_msg_error(model.board.gamedata.err_game_not_started)
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)
			else

				model.board.message.clear_msg_error_reference		-- clear '(= stateX)' message

				model.board.set_gameover

				-- clear all previous messages
				model.board.message.clear_msg_command

				model.board.message.set_msg_error(model.board.gamedata.err_ok)
				model.board.message.set_msg_command (model.board.gamedata.err_gave_up)

				-- check if game is over.
				if model.board.get_gameover then
					-- transfer data to model. Some are done when debig_test or new_game
					-- give_up shouldn't update total_score
					--model.update_current_total_score
					model.board.history.remove_all	-- clear all history to stop undo redo
					model.set_give_up(True) -- used when restart game
				end
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
		end

end
