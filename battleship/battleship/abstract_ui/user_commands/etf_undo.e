note
	description: "Summary description for {ETF_UNDO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO

inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
feature -- command
	undo
    	do

			if model.board.history.after then
				model.board.history.back
			end

			if model.board.history.on_item then
				model.board.history.item.undo

				print("%NUNDO messages: " + model.board.history.item.get_stateNum.out + ": " + model.board.history.item.get_msg_error.out + " -> " + model.board.history.item.get_msg_command.out)
				model.set_msg_error (model.board.history.item.get_msg_error)
				model.set_msg_command (model.board.history.item.get_msg_command)

				model.board.history.back

			else
				model.set_msg_error(model.board.gamedata.err_nothing_to_undo)
				if model.board.check_fire_happened then
					model.set_msg_command (model.board.gamedata.msg_keep_fire)
				else
					model.set_msg_command (model.board.gamedata.msg_fire_away)
				end
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end

