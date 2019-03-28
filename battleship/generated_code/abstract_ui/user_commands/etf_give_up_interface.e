note
	description: "Summary description for {ETF_GIVE_UP_INTERFACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_GIVE_UP_INTERFACE
inherit
	ETF_COMMAND
		redefine
			make
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent give_up
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				TRUE
			then
				out := "give_up"
			else
				etf_cmd_error := True
			end
		end

feature -- command
	give_up
    	deferred
    	end
end

