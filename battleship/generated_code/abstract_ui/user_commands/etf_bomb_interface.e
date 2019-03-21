note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_BOMB_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent bomb(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {TUPLE[row: INTEGER_64; column: INTEGER_64]} etf_cmd_args[1] as coordinate1 and then attached {TUPLE[row: INTEGER_64; column: INTEGER_64]} etf_cmd_args[2] as coordinate2
			then
				out := "bomb(" + etf_event_argument_out("bomb", "coordinate1", coordinate1) + "," + etf_event_argument_out("bomb", "coordinate2", coordinate2) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	bomb_precond(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64] ; coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64]): BOOLEAN
		do  
			Result := 
				         is_coordinate(coordinate1)
					-- (( coordinate1.row ~ A ) or else ( coordinate1.row ~ B ) or else ( coordinate1.row ~ C ) or else ( coordinate1.row ~ D ) or else ( coordinate1.row ~ E ) or else ( coordinate1.row ~ F ) or else ( coordinate1.row ~ G ) or else ( coordinate1.row ~ H ) or else ( coordinate1.row ~ I ) or else ( coordinate1.row ~ J ) or else ( coordinate1.row ~ K ) or else ( coordinate1.row ~ L ))
					-- and then (1 <= coordinate1.column) and then (coordinate1.column <= 12)
				and then is_coordinate(coordinate2)
					-- (( coordinate2.row ~ A ) or else ( coordinate2.row ~ B ) or else ( coordinate2.row ~ C ) or else ( coordinate2.row ~ D ) or else ( coordinate2.row ~ E ) or else ( coordinate2.row ~ F ) or else ( coordinate2.row ~ G ) or else ( coordinate2.row ~ H ) or else ( coordinate2.row ~ I ) or else ( coordinate2.row ~ J ) or else ( coordinate2.row ~ K ) or else ( coordinate2.row ~ L ))
					-- and then (1 <= coordinate2.column) and then (coordinate2.column <= 12)
		ensure then  
			Result = 
				         is_coordinate(coordinate1)
					-- (( coordinate1.row ~ A ) or else ( coordinate1.row ~ B ) or else ( coordinate1.row ~ C ) or else ( coordinate1.row ~ D ) or else ( coordinate1.row ~ E ) or else ( coordinate1.row ~ F ) or else ( coordinate1.row ~ G ) or else ( coordinate1.row ~ H ) or else ( coordinate1.row ~ I ) or else ( coordinate1.row ~ J ) or else ( coordinate1.row ~ K ) or else ( coordinate1.row ~ L ))
					-- and then (1 <= coordinate1.column) and then (coordinate1.column <= 12)
				and then is_coordinate(coordinate2)
					-- (( coordinate2.row ~ A ) or else ( coordinate2.row ~ B ) or else ( coordinate2.row ~ C ) or else ( coordinate2.row ~ D ) or else ( coordinate2.row ~ E ) or else ( coordinate2.row ~ F ) or else ( coordinate2.row ~ G ) or else ( coordinate2.row ~ H ) or else ( coordinate2.row ~ I ) or else ( coordinate2.row ~ J ) or else ( coordinate2.row ~ K ) or else ( coordinate2.row ~ L ))
					-- and then (1 <= coordinate2.column) and then (coordinate2.column <= 12)
		end 
feature -- command 
	bomb(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64] ; coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require 
			bomb_precond(coordinate1, coordinate2)
    	deferred
    	end
end
