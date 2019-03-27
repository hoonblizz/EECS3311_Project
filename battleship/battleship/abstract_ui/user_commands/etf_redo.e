note
	description: "Summary description for {ETF_REDO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make

feature -- query
	undoRedo_msg_format(stateNum: INTEGER; errmsg: STRING): STRING
		do
			Result := "(= state " + stateNum.out + ") " + errmsg
		end

feature -- command
	redo
		local
			errMsg: STRING
    	do
			-- forth
			if
				model.board.history.before
				or not model.board.history.after
			then
				model.board.history.forth
			end

			-- redo
			if model.board.history.on_item then
				model.board.history.item.redo

				-- clear messages before display
				model.clear_msg_command
				model.board.clear_msg_command

				-- Get messages from HISTORY and stack to message board
				print("%NREDO ["+ model.board.history.item.get_op_name.out +"] messages: " + model.board.history.item.get_stateNum.out + ": " + model.board.history.item.get_msg_error.out + " -> " + model.board.history.item.get_msg_command.out)
				errMsg := undoRedo_msg_format(model.board.history.item.get_stateNum, model.board.history.item.get_msg_error)
				model.set_msg_error (errMsg)
				model.set_msg_command (model.board.history.item.get_msg_command)


			else
				--model.set_message ("nothing to redo")
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
