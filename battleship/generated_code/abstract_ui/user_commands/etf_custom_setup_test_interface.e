note
	description: "Summary description for {ETF_CUSTOM_SETUP_TEST_INTERFACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_CUSTOM_SETUP_TEST_INTERFACE
inherit
	ETF_COMMAND
		redefine
			make
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent custom_setup_test(?,?,?,?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER} etf_cmd_args[1] as dimension and then
				attached {INTEGER} etf_cmd_args[2] as ships and then
				attached {INTEGER} etf_cmd_args[3] as max_shots and then
				attached {INTEGER} etf_cmd_args[4] as num_bombs
			then
				out := "custom_setup_test(" + etf_event_argument_out("custom_setup_test", "dimension", dimension)+ "," +
						 etf_event_argument_out("custom_setup_test", "ships", ships) + "," +
						 etf_event_argument_out("custom_setup_test", "max_shots", max_shots) + "," +
						 etf_event_argument_out("custom_setup_test", "num_bombs", num_bombs) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- precond
	custom_setup_test_precond(dimension: INTEGER; ships: INTEGER; max_shots: INTEGER; num_bombs: INTEGER)
		do
			--Result := True
		end

feature -- command
	custom_setup_test(dimension: INTEGER; ships: INTEGER; max_shots: INTEGER; num_bombs: INTEGER)
		require
			--custom_setup_test_precond(dimension, ships, max_shots, num_bombs)
    	deferred
    	end

end

