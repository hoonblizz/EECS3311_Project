note
	description: "[
		The {RANDOM_GENERATOR} class is used to generate 
		coordinates to place ships on the board. Each
		set represents a new ship and can be attained
		by calling forth.
	]"
	author: "Joshua Phillip"
	date: "June 18th, 2018"
	revision: "1"

class
	RANDOM_GENERATOR

create
	make_debug, make_random

feature{NONE} -- atributues

	c_seed, r_seed, d_seed: RANDOM
			-- used to generate random numbers


feature{NONE} -- creation

	make_debug
			-- returns random variables for debug purposes
			-- random variables are deterministic
		do
			create d_seed.make
			create c_seed.make
			create r_seed.set_seed (d_seed.default_seed + 1)
		end

	make_random
			-- returns random variables that are non-deterministic
		local
			time: TIME
			seed: INTEGER
		do
			create time.make_now
			seed := time.hour
			seed := seed * 60 + time.minute
			seed := seed * 60 + time.second
			seed := seed * 1000 + time.milli_second
			create d_seed.set_seed (seed)
			create c_seed.set_seed (seed + (seed \\ 10))
			create r_seed.set_seed (seed)
		end

feature -- queries

	column: INTEGER
			-- returns a random variable used to generate column coordinates
		do
			result := c_seed.item
		end

	row :INTEGER
			-- returns a random variable used to generate row coordinates
		do
			result := r_seed.item
		end

	direction: INTEGER
			-- returns a random variable used to generate direction
		do
			result := d_seed.item
		end

feature -- commands

	forth
			-- sets the row, column and direction variables forward
			-- should be called for a new ship or if there is a collision
		do
			c_seed.forth
			r_seed.forth
			d_seed.forth
		end

end
