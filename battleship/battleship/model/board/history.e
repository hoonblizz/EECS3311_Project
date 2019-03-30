note
	description: "Summary description for {HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

create
	make

feature{NONE} -- create
	make
		do
			create {ARRAYED_LIST[OPERATION]}history.make (10)
		end

	history: LIST[OPERATION]
		-- a history list of user invoked operations
		-- implementation


feature -- queries
	item: OPERATION
			-- Cursor points to this user operation
		require
			on_item
		do
			Result := history.item
		end

	on_item: BOOLEAN
			-- cursor points to a valid operation
			-- cursor is not before or after
		do
			Result := not history.before and not history.after
		end


	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?
		do
			--print("%NHISTORY - Check index, count: " + history.index.out + " = " + history.count.out + " + 1")
			Result := history.index = history.count + 1
		end

	before: BOOLEAN
			-- Is there no valid cursor position to the left of cursor?
		do
			Result := history.index = 0
		end

	isfirst: BOOLEAN
		do Result := history.isfirst end

	islast: BOOLEAN
		do Result := history.islast end


feature -- comands
	extend_history(a_op: OPERATION)
			-- remove all operations to the right of the current
			-- cursor in history, then extend with `a_op'
		do
			--print("%NExtending...")
			--display_cursor_stateNum

			--history.start
			--print("%NAfter start: ")
			--display_cursor_stateNum

			remove_right
			history.extend(a_op)
			history.finish

		ensure
			history[history.count] = a_op
		end

	remove_right
			--remove all elements
			-- to the right of the current cursor in history
		do
			if not history.islast and not history.after then
				from
					history.forth
				until
					history.after
				loop
					print("%NRemoving....")
					history.remove
				end
			end
		end

	-- when Player win or lose. Reset to stop undo, redo
	--	from first element of history until 'no after', remove elements
	remove_all
		do
			create {ARRAYED_LIST[OPERATION]}history.make (10)
		end


	forth
		require
			not after
		do
			history.forth
			print("%NForwarding....")
			display_cursor_stateNum

		end

	back
		require
			not before
		do
			history.back
			print("%NBacking....")
			display_cursor_stateNum
		end


	display_all		-- only for testing. See all contents
		do
			print("%N------------")
			print("%N   HISTORY: ")
			display_cursor_stateNum
			across history as el loop
				print("%N>>>>>>>>>>>")
				print("%NOP Name: " + el.item.get_op_name.out)
				print("%Nstate " + el.item.get_statenum.out)
				print(" " + el.item.get_msg_error.out)
				print(" -> " + el.item.get_msg_command.out)
				print("%NBoard...%N")
				across el.item.get_implementation as im loop print(im.item.out + " ") end
			end
			print("%N------------%N")
		end

	display_cursor_stateNum
		do
			if on_item then
				print("Cursor Pos State: [ " + history.item.get_statenum.out + " ]")
			else
				print("Cursor NOT VALID: [First? " + history.isfirst.out + ", Last? " + history.islast.out + "]")
			end
		end

end
