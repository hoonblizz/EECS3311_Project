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
	msg_reference_format(stateNum: INTEGER): STRING
		do
			Result := "(= state " + stateNum.out + ") "
		end

feature -- command
	redo
		local
			err_ref: STRING
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

				-- clear messages before display. Execution THEN clear <!!
				-- For ETF_FIRE, clearing message is done in mark_fire (right BEFORE execution command)in BOARD
				--				and 'set_msg_command_from_board' in MODEL which is used in
				--				ETF_FIRE AFTER execution.
				model.clear_msg_command
				model.board.clear_msg_command

				-- Get messages from HISTORY and stack to message board
				print("%NREDO ["+ model.board.history.item.get_op_name.out +"] messages: " + model.board.history.item.get_stateNum.out + ": " + model.board.history.item.get_msg_error.out + " -> " + model.board.history.item.get_msg_command.out)
				err_ref := msg_reference_format(model.board.history.item.get_stateNum)
				model.set_msg_error_reference (err_ref)
				model.set_msg_error (model.board.history.item.get_msg_error)
				model.set_msg_command (model.board.history.item.get_msg_command)

				model.board.history.display_all	-- just for testing

			else

				-- clear messages before display
				model.clear_msg_command
				model.board.clear_msg_command

				model.set_msg_error(model.board.gamedata.err_nothing_to_redo)

				if not model.board.started then
					model.set_msg_command (model.board.gamedata.msg_start_new)
				elseif model.board.check_fire_happened then
					model.set_msg_command (model.board.gamedata.msg_keep_fire)
				else
					model.set_msg_command (model.board.gamedata.msg_fire_away)
				end
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
