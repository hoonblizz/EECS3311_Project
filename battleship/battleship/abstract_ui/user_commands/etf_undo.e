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
	msg_reference_format(stateNum: INTEGER): STRING
		do
			Result := "(= state " + stateNum.out + ") "
		end

feature -- command
	msg_nothing_to_undo
		do
			model.board.message.set_msg_error(model.board.gamedata.err_nothing_to_undo)

			if not model.board.get_started then
				model.board.message.set_msg_command (model.board.gamedata.msg_start_new)
			elseif model.board.check_fire_happened then
				model.board.message.set_msg_command (model.board.gamedata.msg_keep_fire)
			else
				model.board.message.set_msg_command (model.board.gamedata.msg_fire_away)
			end
		end

feature -- command
	undo
		local
			err_ref: STRING	-- for undo redo
			stateNum: INTEGER
			msgError, msgCommand: STRING
			op_name: STRING
			old_board: ARRAY2[CHARACTER]
    	do

    		--print("%N===================================")
			--print("%N========== ["+ model.numberOfCommand.out + "] UNDO called ")
			--print("%N===================================")

			if model.board.history.after then		-- no valid cursor on right
				model.board.history.back
			end


			if model.board.history.on_item then

				-- Copy messages Before BACK.
				-- 	In case, after back, it's empty.
				op_name := model.board.history.item.get_op_name
				stateNum := model.board.history.item.get_statenum
				msgError := model.board.history.item.get_msg_error
				msgCommand := model.board.history.item.get_msg_command
				old_board := model.board.history.item.get_implementation



				model.board.history.item.undo

				-- clear messages before display. Execution THEN clear <!!
				-- For ETF_FIRE, clearing message is done in mark_fire (right BEFORE execution command)in BOARD
				--				and 'set_msg_command_from_board' in MODEL which is used in
				--				ETF_FIRE AFTER execution.
				model.board.message.clear_msg_command

				model.board.history.back

				if model.board.history.on_item then

					-- Back, then item exists. Take this item.
					op_name := model.board.history.item.get_op_name
					stateNum := model.board.history.item.get_statenum
					msgError := model.board.history.item.get_msg_error
					msgCommand := model.board.history.item.get_msg_command
					old_board := model.board.history.item.get_implementation


					err_ref := msg_reference_format(stateNum)
					model.board.message.set_msg_error_reference (err_ref)
					model.board.message.set_msg_error (msgError)
					model.board.message.set_msg_command (msgCommand)


				else
					--print("%NAfter back, on_item is not valid.......!!!")

					-- clear messages before display
					model.board.message.clear_msg_command
					model.board.message.clear_msg_error_reference

					msg_nothing_to_undo

					-- check if other items still exist. then move forward
					--print("%NCheck history NOT exist on right: " + model.board.history.after.out)
					if not model.board.history.after then
						model.board.history.forth
					end

				end

				model.board.paste_on_board(old_board)

				--print("%NUNDO ["+ op_name.out +"] messages: " + stateNum.out + ": " + msgError.out + " -> " + msgCommand.out)

			else

				-- clear messages before display
				model.board.message.clear_msg_command
				model.board.message.clear_msg_error_reference

				msg_nothing_to_undo

			end

			--print("%N HISTORY AFTER - UNDO")
			--model.board.history.display_all	-- just for testing

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end

