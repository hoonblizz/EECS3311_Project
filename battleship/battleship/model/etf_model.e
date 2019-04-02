note
	description: "[A default business model.]"
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do

			-- When make model, init random ship generator
			init_gen_ship
			create generated_ships_temp.make (20)
			create generated_ships.make (20)

			make_board (4, False, False, 0, 0, 0, 0)

			numberOfCommand := 0
			current_game := 0
			current_total_score := 0
			current_total_score_limit := 0
			prev_total_score := 0
			prev_total_score_limit := 0

			current_game_mode := ""

			set_give_up(False)

		end

feature -- board

    make_board(level: INTEGER; custom: BOOLEAN; debug_mode: BOOLEAN; dimension: INTEGER; ships: INTEGER; max_shots: INTEGER; num_bombs: INTEGER)
    	-- 13, 14, 15, 16 (easy, medium, hard, advanced)
    	--require
    	--	12 < level and level < 17
    	local
    		boardSize, shipLimit: INTEGER
    		gamedata: GAMEDATA
    	do
			create gamedata.make (0, False, False, 0, 0, 0, 0)	-- temporary usage

			if custom then
				boardSize := dimension
				shipLimit := ships
			else
				boardSize := gamedata.get_board_size (level)
				shipLimit := gamedata.get_ship_limit (level)
			end

			-- Generate ships AFTER gamedata creation
			generated_ships_temp := gen_ship.generate_ships (debug_mode, boardSize, shipLimit)
			generated_ships := reform_generated_ships(generated_ships_temp)

    		create board.make(level, custom, debug_mode, generated_ships, dimension, ships, max_shots, num_bombs)

    	end

    board: BOARD

feature -- Ship generator
	gen_ship: GEN_SHIP		-- use to generate ships in random
	generated_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]
	generated_ships_temp: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]
	-- Why need? because generated_ship is not exactly matching in debug_test mode
	-- when vertical (dir is True) add 1 to x (row)
	-- when not vertical (dir is false) add 1 to y (col)
	reform_generated_ships(ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]): ARRAYED_LIST[TUPLE[INTEGER, INTEGER, INTEGER, BOOLEAN]]
		do
			create Result.make (20)
			across ships as ship
			loop

				if ship.item.dir then
					Result.extend([ship.item.size, ship.item.row + 1, ship.item.col, ship.item.dir])
				else
					Result.extend([ship.item.size, ship.item.row, ship.item.col + 1, ship.item.dir])
				end
			end


		end
	init_gen_ship
		do
			create gen_ship.make_empty
		end

feature -- model attributes
	numberOfCommand : INTEGER

	-- These values don't change when new game started.
	current_game: INTEGER -- number of game currently running
	current_total_score, current_total_score_limit: INTEGER
	current_game_mode: STRING	-- For when different mode started, reset model data'debug_test', 'new_game', 'custom_setup', 'custom_setup_test'

	give_up: BOOLEAN		-- when give up, this be true and affect when new game starts
	set_give_up(val: BOOLEAN)
		do give_up := val end
	get_give_up: BOOLEAN
		do Result := give_up end

	-- Previous score when win / lose happens -> used for give_up then restart
	prev_total_score, prev_total_score_limit: INTEGER
	update_prev_score
		do
			prev_total_score := current_total_score
			prev_total_score_limit := current_total_score_limit
		end

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			numberOfCommand := numberOfCommand + 1
		end

	-- these updates are from 'BOARD.GAMEDATA' to 'MODEL'
	--		See BOARD for comparison
	update_current_game		-- only updated when debug_test or new_game
		do
			current_game := current_game + 1
		end

	update_current_total_score	-- for realtime update in score_out.
		do
			current_total_score := board.gamedata.get_current_total_score
		end

	update_current_total_score_limit
		do
			current_total_score_limit := current_total_score_limit + board.gamedata.get_current_score_limit
		end

	set_game_mode(mode: STRING)
		do
			current_game_mode := mode
		end

	reset
			-- Reset model state.
		do
			make
		end

	reset_values
		do
			--numberOfCommand := 0		-- this should be continuous
			current_game := 0
			current_total_score := 0
			current_total_score_limit := board.gamedata.get_current_score_limit
		end

	-- update current game, total score, total score limit
	-- 	in both 'model', 'model.board.gamedata' level.
	--	so when modificatino happens in 'BOARD.GAMEDATA',
	--	In MODEL, before update score texts,
	-- 	update new values from board.gamedata then display its value in MODEL (score_out).	
	start_game_data_setting(level: INTEGER; custom: BOOLEAN; debug_mode: BOOLEAN)
		local
			mode: STRING
			total_score_limit: INTEGER
		do

			mode := board.gamedata.get_game_mode(custom, debug_mode)

			if current_game_mode /~ mode then

				reset_values -- Different mode. Reset model values.

			else

				-- Same mode. Check it ended up with give_up
				if not get_give_up then

					update_current_game
					-- GAMEDATA to MODEL
					update_current_total_score_limit
					--model.update_current_total_score -- done when gameover

				else

					if prev_total_score ~ 0 and prev_total_score_limit ~ 0 then
						current_total_score := board.gamedata.get_current_score
						current_total_score_limit := board.gamedata.get_current_score_limit
					else
						current_total_score := prev_total_score
						current_total_score_limit := prev_total_score_limit
					end

				end
			end

			set_game_mode(mode)
			-- Need to reset games when started new
			set_give_up(False)

			-- in case, new_game -> give_up -> custom_setup_test
			--	Then, current_game stays 0
			--	because it's been reset to 0 then given_up doesn't allow to update
			if current_game < 1 then
				update_current_game
			end

			-- MODEL to GAMEDATA
			board.gamedata.update_current_game(board.gamedata.get_current_game)
			board.gamedata.update_current_total_score(current_total_score)
			board.gamedata.update_current_total_score_limit(current_total_score_limit)

		end


feature -- queries


	out : STRING
		do

			create Result.make_from_string (board.message_out(numberOfCommand))

			update_current_total_score -- update total_score. GAMEDATA -> MODEL

			Result.append (board.board_out)
			Result.append (board.score_out(current_game, current_total_score, current_total_score_limit))

		end

end




