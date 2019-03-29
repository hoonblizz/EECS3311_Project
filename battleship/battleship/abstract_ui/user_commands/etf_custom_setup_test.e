note
	description: "Summary description for {ETF_CUSTOM_SETUP_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_CUSTOM_SETUP_TEST
inherit
	ETF_CUSTOM_SETUP_TEST_INTERFACE
		redefine custom_setup_test end
create
	make

feature -- command
	custom_setup_test(dimension: INTEGER; ships: INTEGER; max_shots: INTEGER; num_bombs: INTEGER)
		do
			print("%NCustom setup test.....!!")


			etf_cmd_container.on_change.notify ([Current])
		end

end
