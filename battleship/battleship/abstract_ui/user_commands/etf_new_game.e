note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_GAME
inherit 
	ETF_NEW_GAME_INTERFACE
		redefine new_game end
create
	make
feature -- command 
	new_game(level: INTEGER_64)
		require else 
			new_game_precond(level)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
