note
	description: "[
		Just collection of game data. For example, default values of limits with
		different difficulties of the game.
		GAMEDATA is like a global that will be created when BOARD is make. Like HISTORY.
		Some Data like current_game and total score is placed in ETF_MODEL
		
		Ship generation occurs here but actual display will be done by 'implementation' in BOARD
	]"
	author: "Taehoon Kim"
	date: "$Date$"
	revision: "$Revision$"

class
	GAMEDATA

create
	make

feature {NONE}
	-- level will be 13, 14, 15, 16 (easy, medium, hard, advanced)
	make(level: INTEGER; custom: BOOLEAN; debug_mode: BOOLEAN; dimension: INTEGER; ships: INTEGER; max_shots: INTEGER; num_bombs: INTEGER)
		do
			if custom then
				set_game_default_value_custom(dimension, ships, max_shots, num_bombs)
			else
				set_game_default_value(level)
			end

			row_chars := <<"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L">>

			create generated_ships.make (20)

		end

feature {NONE} -- attributes

	-- if direction is true, vertical
	generated_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]

	-- 13, 14, 15, 16 (easy, medium, hard, advanced)
	-- current_ships:   currently "taken down" ships.
	current_game: INTEGER

	-- variables that must be set or reset
	current_level_int: INTEGER
	current_board_size: INTEGER
	current_fire, current_bomb, current_score, current_total_score, current_ships: INTEGER
	current_fire_limit, current_bomb_limit, current_score_limit, current_total_score_limit, current_ships_limit: INTEGER

feature  -- default values and messages

	-- default values
	row_chars: ARRAY[STRING]

	game_mode_debug_test: STRING = "debug_test"
	game_mode_new_game: STRING = "new_game"
	game_mode_custom_setup: STRING = "custom_setup"
	game_mode_custom_setup_test: STRING = "custom_setup_test"

	easy_level_str: STRING = "easy"
	easy_level_int: INTEGER = 13
	easy_board_size: INTEGER = 4		-- easy game attributes
	easy_fire_limit : INTEGER = 8
	easy_bomb_limit : INTEGER = 2
	easy_score_limit : INTEGER = 3
	easy_ships_limit : INTEGER = 2

	medium_level_str: STRING = "medium"
	medium_level_int: INTEGER = 14
	medium_board_size: INTEGER = 6	-- medium game attributes
	medium_fire_limit : INTEGER = 16
	medium_bomb_limit : INTEGER = 3
	medium_score_limit : INTEGER = 6
	medium_ships_limit : INTEGER = 3

	hard_level_str: STRING = "hard"
	hard_level_int: INTEGER = 15
	hard_board_size: INTEGER = 8		-- hard game attributes
	hard_fire_limit : INTEGER = 24
	hard_bomb_limit : INTEGER = 5
	hard_score_limit : INTEGER = 15
	hard_ships_limit : INTEGER = 5

	advanced_level_str: STRING = "advanced"
	advanced_level_int: INTEGER = 16
	advanced_board_size: INTEGER = 12		-- advanced game attributes
	advanced_fire_limit : INTEGER = 40
	advanced_bomb_limit : INTEGER = 7
	advanced_score_limit : INTEGER = 28
	advanced_ships_limit : INTEGER = 7

	-- Game Messages and Error messages
	msg_start_new: STRING = "Start a new game"
	msg_fire_away: STRING = "Fire Away!"
	msg_keep_fire: STRING = "Keep Firing!"
	msg_hit: STRING = "Hit!"
	msg_miss: STRING = "Miss!"
	msg_win: STRING = "You Win!"
	msg_game_over: STRING = "Game Over!"

	err_ok: STRING = "OK"
	-- For new game, debug game
	err_game_already_started: STRING = "Game already started"
	-- For Fire and bomb
	err_game_not_started: STRING = "Game not started"
	err_invalid_coord: STRING = "Invalid coordinate"
	err_already_fired_coord: STRING ="Already fired there"
	-- For fire only
	err_no_shots: STRING ="No shots remaining"
	--For bomb only
	err_no_bomb: STRING ="No bombs remaining"
	err_adjacent_coord: STRING = "Bomb coordinates must be adjacent"

	-- undo, redo
	err_nothing_to_undo: STRING = "Nothing to undo"
	err_nothing_to_redo: STRING = "Nothing to redo"

	-- custom_setup, custom_setup_test
	err_not_enough_ships: STRING = "Not enough ships"
	err_too_many_ships: STRING = "Too many ships"
	err_not_enough_shots: STRING = "Not enough shots"
	err_too_many_shots: STRING = "Too many shots"
	err_not_enough_bombs: STRING = "Not enough bombs"
	err_too_many_bombs: STRING = "Too many bombs"

	-- giveup
	err_gave_up: STRING = "You gave up!"

	msg_ship_sunk(shipSize: INTEGER): STRING
		do
			Result := shipSize.out + "x1 ship sunk!"
		end

	msg_ships_sunk(shipSize1: INTEGER; shipSize2: INTEGER): STRING
		do
			Result := shipSize1.out + "x1 and " + shipSize2.out +"x1 ships sunk!"
		end

feature -- update values

	-- these updates are from 'MODEL' value to 'BOARD.GAMEDATA'
	--		see ETF_NEW_GAME.
	update_current_game(val: INTEGER)
		do
			current_game := val
		end
	update_current_total_score(val: INTEGER)
		do
			current_total_score := val
		end
	update_current_total_score_limit(val: INTEGER)
		do
			current_total_score_limit := val
		end

	add_score(shipSize: INTEGER)
		do
			current_score := current_score + shipSize
			current_total_score := current_total_score + shipSize
		end
	add_shot
		do
			current_fire := current_fire + 1
		end
	add_bomb
		do
			current_bomb := current_bomb + 1
		end
	add_ship
		do
			current_ships := current_ships + 1
		end

	sub_score(shipSize: INTEGER)
		do
			current_score := current_score - shipSize
			current_total_score := current_total_score - shipSize
		end
	sub_shot
		do
			current_fire := current_fire - 1
		end
	sub_bomb
		do
			current_bomb := current_bomb - 1
		end
	sub_ship
		do
			current_ships := current_ships - 1
		end

	-- For undo, redo. See OPERTION_FIRE
	update_shots(shots: INTEGER)
		do current_fire := shots end
	update_bombs(bombs: INTEGER)
		do current_bomb := bombs end
	update_ships(ships: INTEGER)
		do current_ships := ships end
	update_score(score: INTEGER)
		do current_score := score end
	update_total_score(score: INTEGER)
		do current_total_score := score end


feature --query

	-- Get series. Prevents client to modify gamedata values
	get_generated_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]
		do Result := generated_ships end

	get_current_game: INTEGER
		do Result := current_game end

	get_current_level_int: INTEGER
		do Result := current_level_int end

	get_current_board_size: INTEGER
		do Result := current_board_size end

	get_current_fire: INTEGER
		do Result := current_fire end

	get_current_bomb: INTEGER
		do Result := current_bomb end

	get_current_score: INTEGER
		do Result := current_score end

	get_current_total_score: INTEGER
		do Result := current_total_score end

	get_current_ships: INTEGER
		do Result := current_ships end

	get_current_fire_limit: INTEGER
		do Result := current_fire_limit end

	get_current_bomb_limit: INTEGER
		do Result := current_bomb_limit end

	get_current_score_limit: INTEGER
		do Result := current_score_limit end

	get_current_total_score_limit: INTEGER
		do Result := current_total_score_limit end

	get_current_ships_limit: INTEGER
		do Result := current_ships_limit end

	get_level_int(level_str: INTEGER_64): INTEGER
		do
			if level_str ~ easy_level_str then
				Result := easy_level_int
			elseif level_str ~ medium_level_str then
				Result := medium_level_int
			elseif level_str ~ hard_level_str then
				Result := hard_level_int
			elseif level_str ~ advanced_level_str then
				Result := advanced_level_int
			end
		end
	get_board_size(level: INTEGER): INTEGER
		do
			if level ~ easy_level_int then
				Result := easy_board_size
			elseif level ~ medium_level_int then
				Result := medium_board_size
			elseif level ~ hard_level_int then
				Result := hard_board_size
			elseif level ~ advanced_level_int then
				Result := advanced_board_size
			end
		end

	get_score_limit(level: INTEGER): INTEGER
		do
			if level ~ easy_level_int then
				Result := easy_score_limit
			elseif level ~ medium_level_int then
				Result := medium_score_limit
			elseif level ~ hard_level_int then
				Result := hard_score_limit
			elseif level ~ advanced_level_int then
				Result := advanced_score_limit
			end
		end

	get_game_mode(customMode: BOOLEAN; debugMode: BOOLEAN): STRING
		do
			if customMode and debugMode then
				Result := game_mode_custom_setup_test
			elseif customMode and not debugMode then
				Result := game_mode_custom_setup
			elseif not customMode and debugMode then
				Result := game_mode_debug_test
			elseif not customMode and not debugMode then
				Result := game_mode_new_game
			else
				Result := ""
			end
		end

	get_ship_limit(level: INTEGER): INTEGER
		do
			if level ~ easy_level_int then
				Result := easy_ships_limit
			elseif level ~ medium_level_int then
				Result := medium_ships_limit
			elseif level ~ hard_level_int then
				Result := hard_ships_limit
			elseif level ~ advanced_level_int then
				Result := advanced_ships_limit
			end
		end



feature --command
	set_game_default_value (level: INTEGER)
		do
			if level ~ easy_level_int then

				current_level_int := level
				current_board_size := easy_board_size
				current_fire := 0
				current_bomb := 0
				current_score := 0
				current_ships := 0
				current_fire_limit := easy_fire_limit
				current_bomb_limit := easy_bomb_limit
				current_score_limit := easy_score_limit
				current_ships_limit := easy_ships_limit

			elseif level ~ medium_level_int then

				current_level_int := level
				current_board_size := medium_board_size
				current_fire := 0
				current_bomb := 0
				current_score := 0
				current_ships := 0
				current_fire_limit := medium_fire_limit
				current_bomb_limit := medium_bomb_limit
				current_score_limit := medium_score_limit
				current_ships_limit := medium_ships_limit

			elseif level ~ hard_level_int then

				current_level_int := level
				current_board_size := hard_board_size
				current_fire := 0
				current_bomb := 0
				current_score := 0
				current_ships := 0
				current_fire_limit := hard_fire_limit
				current_bomb_limit := hard_bomb_limit
				current_score_limit := hard_score_limit
				current_ships_limit := hard_ships_limit

			elseif level ~ advanced_level_int then

				current_level_int := level
				current_board_size := advanced_board_size
				current_fire := 0
				current_bomb := 0
				current_score := 0
				current_ships := 0
				current_fire_limit := advanced_fire_limit
				current_bomb_limit := advanced_bomb_limit
				current_score_limit := advanced_score_limit
				current_ships_limit := advanced_ships_limit

			end
		end

	set_game_default_value_custom(dimension: INTEGER; ships: INTEGER; max_shots: INTEGER; num_bombs: INTEGER)
		local
			total_score: INTEGER
		do
			current_level_int := 99
			current_board_size := dimension
			current_fire := 0
			current_bomb := 0
			current_score := 0
			current_ships := 0
			current_fire_limit := max_shots
			current_bomb_limit := num_bombs
			current_ships_limit := ships
			-- Total Score is related to Size of ship
			total_score := 0
			across 1 |..| ships as i loop
				total_score := total_score + i.item
			end
			current_score_limit := total_score

		end

	-- properly formed ship locations
	set_generated_ships(gs: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]])
		do
			generated_ships := gs
		end

	test_ships_generated	-- test random generation of ships
		do
			--just to display (testing)
			--across
			--	generated_ships as ship
			--loop
				--print("%NShip Size: " + ship.item.size.out + ", Pos: [" + ship.item.row.out + ", " + ship.item.col.out + "], Dir: " + ship.item.dir.out)
			--end
		end

end
