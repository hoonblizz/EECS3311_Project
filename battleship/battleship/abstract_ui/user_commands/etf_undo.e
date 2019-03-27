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

feature -- query
	undoRedo_msg_format(stateNum: INTEGER; errmsg: STRING): STRING
		do
			Result := "(= state " + stateNum.out + ") " + errmsg
		end

feature -- command
	undo
		local
			errMsg: STRING	-- for undo redo
    	do

			if model.board.history.after then
				print("%NHistory back...")
				model.board.history.back
			end

			if model.board.history.on_item then
				model.board.history.item.undo

				-- clear messages before display
				model.clear_msg_command
				model.board.clear_msg_command

				-- Get messages from HISTORY and stack to message board
				print("%NUNDO ["+ model.board.history.item.get_op_name.out +"] messages: " + model.board.history.item.get_old_stateNum.out + ": " + model.board.history.item.get_old_msg_error.out + " -> " + model.board.history.item.get_old_msg_command.out)
				errMsg := undoRedo_msg_format(model.board.history.item.get_old_stateNum, model.board.history.item.get_old_msg_error)
				model.set_msg_error (errMsg)
				model.set_msg_command (model.board.history.item.get_old_msg_command)

				model.board.history.back

			else
				model.set_msg_error(model.board.gamedata.err_nothing_to_undo)
				if model.board.check_fire_happened then
					model.set_msg_command (model.board.gamedata.msg_keep_fire)
				else
					model.set_msg_command (model.board.gamedata.msg_fire_away)
				end
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end

