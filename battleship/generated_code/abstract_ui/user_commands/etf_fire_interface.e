note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_FIRE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent fire(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {TUPLE[row: INTEGER_64; column: INTEGER_64]} etf_cmd_args[1] as coordinate
			then
				out := "fire(" + etf_event_argument_out("fire", "coordinate", coordinate) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	fire_precond(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64]): BOOLEAN
		do  
			Result := 
				         is_coordinate(coordinate)
					-- (( coordinate.row ~ A ) or else ( coordinate.row ~ B ) or else ( coordinate.row ~ C ) or else ( coordinate.row ~ D ) or else ( coordinate.row ~ E ) or else ( coordinate.row ~ F ) or else ( coordinate.row ~ G ) or else ( coordinate.row ~ H ) or else ( coordinate.row ~ I ) or else ( coordinate.row ~ J ) or else ( coordinate.row ~ K ) or else ( coordinate.row ~ L ))
					-- and then (1 <= coordinate.column) and then (coordinate.column <= 12)
		ensure then  
			Result = 
				         is_coordinate(coordinate)
					-- (( coordinate.row ~ A ) or else ( coordinate.row ~ B ) or else ( coordinate.row ~ C ) or else ( coordinate.row ~ D ) or else ( coordinate.row ~ E ) or else ( coordinate.row ~ F ) or else ( coordinate.row ~ G ) or else ( coordinate.row ~ H ) or else ( coordinate.row ~ I ) or else ( coordinate.row ~ J ) or else ( coordinate.row ~ K ) or else ( coordinate.row ~ L ))
					-- and then (1 <= coordinate.column) and then (coordinate.column <= 12)
		end 
feature -- command 
	fire(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require 
			fire_precond(coordinate)
    	deferred
    	end
end
