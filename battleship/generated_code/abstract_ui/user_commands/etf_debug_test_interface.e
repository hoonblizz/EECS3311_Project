note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_DEBUG_TEST_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent debug_test(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as level
			then
				out := "debug_test(" + etf_event_argument_out("debug_test", "level", level) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	debug_test_precond(level: INTEGER_64): BOOLEAN
		do  
			Result := 
				         is_level(level)
					-- (( level ~ easy ) or else ( level ~ medium ) or else ( level ~ hard ) or else ( level ~ advanced ))
		ensure then  
			Result = 
				         is_level(level)
					-- (( level ~ easy ) or else ( level ~ medium ) or else ( level ~ hard ) or else ( level ~ advanced ))
		end 
feature -- command 
	debug_test(level: INTEGER_64)
		require 
			debug_test_precond(level)
    	deferred
    	end
end
