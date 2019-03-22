note
	description: "[
		Just collection of game data. For example, default values of limits with
		different difficulties of the game.
		GAMEDATA is like a global that will be created when BOARD is make. Like HISTORY.
		Some Data like current_game and total score is placed in ETF_MODEL	
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAMEDATA

create
	make

feature
	-- level will be 13, 14, 15, 16 (easy, medium, hard, advanced)
	make(level: INTEGER)
		do
			set_game_default_value(level)
			row_chars := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'>>
		end

feature --attributes

	-- 13, 14, 15, 16 (easy, medium, hard, advanced)
	-- current_ships:   currently "taken down" ships.
	-- current_game: INTEGER		-- number of games running -> moved to ETF_MODEL

	-- variables that must be set or reset
	current_level_int: INTEGER
	current_board_size: INTEGER
	current_fire, current_bomb, current_score, current_total_score, current_ships: INTEGER
	current_fire_limit, current_bomb_limit, current_score_limit, current_total_score_limit, current_ships_limit: INTEGER

	-- default values
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

	row_chars: ARRAY[CHARACTER]

feature --query
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

end
