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
		local
			op: OPERATION_FIRE
			l_x,l_y: INTEGER
			coord: COORD
    	do
			l_x := coordinate.row.as_integer_32
			l_y := coordinate.column.as_integer_32

			create coord.make (l_x, l_y)
			create op.make (coord)

			-- Start checking error of new coord
			




			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
