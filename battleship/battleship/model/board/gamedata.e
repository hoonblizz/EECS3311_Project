note
	description: "[
		Just collection of game data. For example, default values of limits with
		different difficulties of the game.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAMEDATA

create
	make

feature
	make
		do
			row_chars := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'>>
		end

feature
	easy_board_size: INTEGER = 4		-- easy game attributes
	easy_fire_limit : INTEGER = 8
	easy_bomb_limit : INTEGER = 2
	easy_score_limit : INTEGER = 3
	easy_ships_limit : INTEGER = 2

	medium_board_size: INTEGER = 6	-- medium game attributes
	medium_fire_limit : INTEGER = 16
	medium_bomb_limit : INTEGER = 3
	medium_score_limit : INTEGER = 6
	medium_ships_limit : INTEGER = 3


	hard_board_size: INTEGER = 8		-- hard game attributes
	hard_fire_limit : INTEGER = 24
	hard_bomb_limit : INTEGER = 5
	hard_score_limit : INTEGER = 15
	hard_ships_limit : INTEGER = 5

	advanced_board_size: INTEGER = 12		-- advanced game attributes
	advanced_fire_limit : INTEGER = 40
	advanced_bomb_limit : INTEGER = 7
	advanced_score_limit : INTEGER = 28
	advanced_ships_limit : INTEGER = 7

	row_chars: ARRAY[CHARACTER]

end
