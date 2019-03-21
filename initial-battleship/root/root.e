note
	description: "ROOT class for project"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT
inherit
	ARGUMENTS_32
create
	make

feature -- Initialization

	g: GAME

	make
			-- Run application.
		local
			new_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]]
		do
			create g.make_empty

			print ("%N")
			print ("First call to randomly generate initial positions of the board %N")

			-- Call to `generate_ships' to generate a list of ship coordinates,
			-- each of which consisting of: 1) size of ship; 2) base row and column;
			-- 3) direction of ship (`dir' being true means a vertical ship, false means a horizontal ship)
			new_ships := g.generate_ships (true, g.board.height, 7)
			place_new_ships (g.board, new_ships)
			print (g.out)

			print ("%N")
			print ("Second call to randomly generate initial positions of the board %N")

			g.make_empty
			new_ships := g.generate_ships (true, g.board.height, 7)
			place_new_ships (g.board, new_ships)
			print (g.out)

			print ("%N")
			print ("Third call to randomly generate initial positions of the board %N")

			g.make_empty
			new_ships := g.generate_ships (true, g.board.height, 7)
			place_new_ships (g.board, new_ships)
			print (g.out)
		end

feature

	place_new_ships(board: ARRAY2[SHIP_ALPHABET]; new_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]])
			-- Place the randomly generated positions of `new_ships' onto the `board'.
			-- Notice that when a ship's row and column are given, 
			-- its coordinate starts with (row + 1, col) for a vertical ship,
			-- and starts with (row, col + 1) for a horizontal ship.
		require
			across new_ships.lower |..| new_ships.upper as i all
			across new_ships.lower |..| new_ships.upper as j all
				i.item /= j.item implies not g.collide_with_each_other (new_ships[i.item], new_ships[j.item])
			end
			end
		do
			across
				new_ships as new_ship
			loop
				if new_ship.item.dir then
					-- Vertical ship
					across
						1 |..| new_ship.item.size as i
					loop
						board[new_ship.item.row + i.item, new_ship.item.col] := create {SHIP_ALPHABET}.make ('v')
					end
				else
					-- Horizontal ship
					across
						1 |..| new_ship.item.size as i
					loop
						board[new_ship.item.row, new_ship.item.col + i.item] := create {SHIP_ALPHABET}.make ('h')
					end
				end
			end
		end

end
