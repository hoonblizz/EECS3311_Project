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
feature -- command
	redo
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
				--model.set_message ("ok")
			else
				--model.set_message ("nothing to redo")
			end

			-- push
			etf_cmd_container.on_change.notify ([Current])
    	end

end
