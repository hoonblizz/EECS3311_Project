note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit 
	ETF_FIRE_INTERFACE
		redefine fire end
create
	make
feature -- command 
	fire(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else 
			fire_precond(coordinate)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
