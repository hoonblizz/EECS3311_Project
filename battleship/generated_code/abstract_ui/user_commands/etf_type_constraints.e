class
 	 ETF_TYPE_CONSTRAINTS

feature -- type queries 

	is_column(etf_v: INTEGER_64): BOOLEAN 
		require
			comment("etf_v: COLUMN = 1 .. 12")
		do
			 Result := 
				(1 <= etf_v) and then (etf_v <= 12)
		ensure
			 Result = 
				(1 <= etf_v) and then (etf_v <= 12)
		end

	is_row(etf_v: INTEGER_64): BOOLEAN 
		require
			comment("etf_v: ROW = {A, B, C, D, E, F, G, H, I, J, K, L}")
		do
			 Result := 
				(( etf_v ~ A ) or else ( etf_v ~ B ) or else ( etf_v ~ C ) or else ( etf_v ~ D ) or else ( etf_v ~ E ) or else ( etf_v ~ F ) or else ( etf_v ~ G ) or else ( etf_v ~ H ) or else ( etf_v ~ I ) or else ( etf_v ~ J ) or else ( etf_v ~ K ) or else ( etf_v ~ L ))
		ensure
			 Result = 
				(( etf_v ~ A ) or else ( etf_v ~ B ) or else ( etf_v ~ C ) or else ( etf_v ~ D ) or else ( etf_v ~ E ) or else ( etf_v ~ F ) or else ( etf_v ~ G ) or else ( etf_v ~ H ) or else ( etf_v ~ I ) or else ( etf_v ~ J ) or else ( etf_v ~ K ) or else ( etf_v ~ L ))
		end

	is_coordinate(etf_v: TUPLE[row: INTEGER_64; column: INTEGER_64]): BOOLEAN 
		require
			comment("etf_v: COORDINATE = TUPLE[row: ROW = {A, B, C, D, E, F, G, H, I, J, K, L}; column: COLUMN = 1 .. 12]")
		do
			 Result := 
				         is_row(etf_v.row)
				and then is_column(etf_v.column)
		ensure
			 Result = 
				         is_row(etf_v.row)
				and then is_column(etf_v.column)
		end

	is_level(etf_v: INTEGER_64): BOOLEAN 
		require
			comment("etf_v: LEVEL = {easy, medium, hard, advanced}")
		do
			 Result := 
				(( etf_v ~ easy ) or else ( etf_v ~ medium ) or else ( etf_v ~ hard ) or else ( etf_v ~ advanced ))
		ensure
			 Result = 
				(( etf_v ~ easy ) or else ( etf_v ~ medium ) or else ( etf_v ~ hard ) or else ( etf_v ~ advanced ))
		end

feature -- constants for enumerated items 
	A: INTEGER =1
	B: INTEGER =2
	C: INTEGER =3
	D: INTEGER =4
	E: INTEGER =5
	F: INTEGER =6
	G: INTEGER =7
	H: INTEGER =8
	I: INTEGER =9
	J: INTEGER =10
	K: INTEGER =11
	L: INTEGER =12
	easy: INTEGER =13
	medium: INTEGER =14
	hard: INTEGER =15
	advanced: INTEGER =16

feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
			Result.extend(1, "A")
			Result.extend(2, "B")
			Result.extend(3, "C")
			Result.extend(4, "D")
			Result.extend(5, "E")
			Result.extend(6, "F")
			Result.extend(7, "G")
			Result.extend(8, "H")
			Result.extend(9, "I")
			Result.extend(10, "J")
			Result.extend(11, "K")
			Result.extend(12, "L")
			Result.extend(13, "easy")
			Result.extend(14, "medium")
			Result.extend(15, "hard")
			Result.extend(16, "advanced")
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER_64]
		do
			create Result.make (10)
			Result.extend("A", 1)
			Result.extend("B", 2)
			Result.extend("C", 3)
			Result.extend("D", 4)
			Result.extend("E", 5)
			Result.extend("F", 6)
			Result.extend("G", 7)
			Result.extend("H", 8)
			Result.extend("I", 9)
			Result.extend("J", 10)
			Result.extend("K", 11)
			Result.extend("L", 12)
			Result.extend("easy", 13)
			Result.extend("medium", 14)
			Result.extend("hard", 15)
			Result.extend("advanced", 16)
		end
feature -- query on declarations of event parameters
	evt_param_types_table : HASH_TABLE[HASH_TABLE[ETF_PARAM_TYPE, STRING], STRING]
		local
			new_game_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			debug_test_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			fire_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			bomb_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create new_game_param_types.make (10)
			new_game_param_types.compare_objects
			new_game_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("LEVEL", create {ETF_ENUM_PARAM}.make(<<"easy", "medium", "hard", "advanced">>)), "level")
			Result.extend (new_game_param_types, "new_game")
			create debug_test_param_types.make (10)
			debug_test_param_types.compare_objects
			debug_test_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("LEVEL", create {ETF_ENUM_PARAM}.make(<<"easy", "medium", "hard", "advanced">>)), "level")
			Result.extend (debug_test_param_types, "debug_test")
			create fire_param_types.make (10)
			fire_param_types.compare_objects
			fire_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("COORDINATE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("row", create {ETF_NAMED_PARAM_TYPE}.make("ROW", create {ETF_ENUM_PARAM}.make(<<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L">>))), create {ETF_PARAM_DECL}.make("column", create {ETF_NAMED_PARAM_TYPE}.make("COLUMN", create {ETF_INTERVAL_PARAM}.make(1, 12)))>>)), "coordinate")
			Result.extend (fire_param_types, "fire")
			create bomb_param_types.make (10)
			bomb_param_types.compare_objects
			bomb_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("COORDINATE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("row", create {ETF_NAMED_PARAM_TYPE}.make("ROW", create {ETF_ENUM_PARAM}.make(<<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L">>))), create {ETF_PARAM_DECL}.make("column", create {ETF_NAMED_PARAM_TYPE}.make("COLUMN", create {ETF_INTERVAL_PARAM}.make(1, 12)))>>)), "coordinate1")
			bomb_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("COORDINATE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("row", create {ETF_NAMED_PARAM_TYPE}.make("ROW", create {ETF_ENUM_PARAM}.make(<<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L">>))), create {ETF_PARAM_DECL}.make("column", create {ETF_NAMED_PARAM_TYPE}.make("COLUMN", create {ETF_INTERVAL_PARAM}.make(1, 12)))>>)), "coordinate2")
			Result.extend (bomb_param_types, "bomb")
		end
feature -- query on declarations of event parameters
	evt_param_types_list : HASH_TABLE[LINKED_LIST[ETF_PARAM_TYPE], STRING]
		local
			new_game_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			debug_test_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			fire_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			bomb_param_types: LINKED_LIST[ETF_PARAM_TYPE]
		do
			create Result.make (10)
			Result.compare_objects
			create new_game_param_types.make
			new_game_param_types.compare_objects
			new_game_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("LEVEL", create {ETF_ENUM_PARAM}.make(<<"easy", "medium", "hard", "advanced">>)))
			Result.extend (new_game_param_types, "new_game")
			create debug_test_param_types.make
			debug_test_param_types.compare_objects
			debug_test_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("LEVEL", create {ETF_ENUM_PARAM}.make(<<"easy", "medium", "hard", "advanced">>)))
			Result.extend (debug_test_param_types, "debug_test")
			create fire_param_types.make
			fire_param_types.compare_objects
			fire_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("COORDINATE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("row", create {ETF_NAMED_PARAM_TYPE}.make("ROW", create {ETF_ENUM_PARAM}.make(<<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L">>))), create {ETF_PARAM_DECL}.make("column", create {ETF_NAMED_PARAM_TYPE}.make("COLUMN", create {ETF_INTERVAL_PARAM}.make(1, 12)))>>)))
			Result.extend (fire_param_types, "fire")
			create bomb_param_types.make
			bomb_param_types.compare_objects
			bomb_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("COORDINATE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("row", create {ETF_NAMED_PARAM_TYPE}.make("ROW", create {ETF_ENUM_PARAM}.make(<<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L">>))), create {ETF_PARAM_DECL}.make("column", create {ETF_NAMED_PARAM_TYPE}.make("COLUMN", create {ETF_INTERVAL_PARAM}.make(1, 12)))>>)))
			bomb_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("COORDINATE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("row", create {ETF_NAMED_PARAM_TYPE}.make("ROW", create {ETF_ENUM_PARAM}.make(<<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L">>))), create {ETF_PARAM_DECL}.make("column", create {ETF_NAMED_PARAM_TYPE}.make("COLUMN", create {ETF_INTERVAL_PARAM}.make(1, 12)))>>)))
			Result.extend (bomb_param_types, "bomb")
		end
feature -- comments for contracts
	comment(etf_s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end