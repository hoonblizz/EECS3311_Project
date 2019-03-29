# EECS3311_Project
2018-2019 Winter

## Adding a new command
In this project, number of new command must be registered. <br>
To do that,<br>
First, goto generated_code -> abstract_ui -> user_commands<br>
Open **ETF_TYPE_CONSTRAINTS** and add new command there.
(2 places) <br>

For example, if command is something like<br>
custom_setup(dimension: INTEGER_64, ships: INTEGER_64, max_shots: INTEGER_64, num_bombs: INTEGER_64) <br>
with integer range of dimension => 4~12, ships => 1~7, max_shots => 1~144, num_bombs => 1~7. <br>
Then in feature ``` evt_param_types_table ```, 
```
local
	custom_setup_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
do
	create Result.make (10)
	Result.compare_objects

	create custom_setup_types.make (10)
	custom_setup_types.compare_objects
	custom_setup_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GRID_SIZE", create {ETF_INTERVAL_PARAM}.make (4, 12)), "dimension")
	custom_setup_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("NUMBER_OF_SHIPS", create {ETF_INTERVAL_PARAM}.make (1, 7)), "ships")
	custom_setup_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("MAX_SHOTS", create {ETF_INTERVAL_PARAM}.make (1, 144)), "max_shots")
	custom_setup_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("NUMBER_OF_BOMBS", create {ETF_INTERVAL_PARAM}.make (1, 7)), "num_bombs")

	Result.extend (custom_setup_types, "custom_setup")
end
```
Notice that ETF_INTERVAL_PARAM enables you to set the range of INTEGER.<br>
Do similar to ``` evt_param_types_list ```  <br>
<br>

Second, goto generated_code -> input <br>
Open **ETF_INPUT_HANDLER_INTERFACE** and add new command there.
(2 places) <br>

With the same example custom_setup,<br>
in ``` evt_to_cmd ``` feature, add <br>

```
if cmd_name ~ "custom_setup" then
	if
		attached {ETF_INT_ARG} args[1] as dimension and then 4 <= dimension.value and then dimension.value <= 12 and then
		attached {ETF_INT_ARG} args[2] as ships and then 1 <= ships.value and then ships.value <= 7 and then
		attached {ETF_INT_ARG} args[3] as max_shots and then 1 <= max_shots.value and then max_shots.value <= 144 and then
		attached {ETF_INT_ARG} args[4] as num_bombs and then 1 <= num_bombs.value and then num_bombs.value <= 7
	then

		create {ETF_CUSTOM_SETUP} Result.make("custom_setup", [dimension.value, ships.value, max_shots.value, num_bombs.value], abstract_ui)
	
	else
		Result := dummy_cmd
	end
end
```
Do similar to ``` find_invalid_evt_trace ``` <br>
Notice that this feature is to check if input command is valid. It's like, <br>

```
if cmd_name ~ "custom_setup" then
	if
		NOT( ( args.count = 4 ) AND THEN
			(attached {ETF_INT_ARG} args[1] as dimension) and then 4 <= dimension.value and then dimension.value <= 12 and then
			(attached {ETF_INT_ARG} args[2] as ships) and then 1 <= ships.value and then ships.value <= 7 and then
			(attached {ETF_INT_ARG} args[3] as max_shots) and then 1 <= max_shots.value and then max_shots.value <= 144 and then
			(attached {ETF_INT_ARG} args[4] as num_bombs) and then 1 <= num_bombs.value and then num_bombs.value <= 7)

	then
					
		if NOT Result.is_empty then
			Result.append ("%N")
		end
		Result.append (evt_out_str + " does not conform to declaration (arg: " + args.count.out + ") " +
			"custom_setup(dimension: INTEGER_64={4..12} ; ships: INTEGER_64={1..7}; max_shots: INTEGER_64={1..144}; num_bombs: INTEGER_64={1..7})")

		end

end
```


## Trouble Shooting
### gtk/gtk.h file not found
When this happen, nothing would work but gives a full of error.<br>
Keep calm. Just save all your work and make a copy of it first.<br>
For me, this happened when I changed bash_profile a bit. (I think)<br>
Easiest solution might be update EVERYTHING to get the original setups.<br>
For my case, I just followed professor's instruction once again.

Assume **Xcode, X11 and MacPort** is already installed.
Then,
```
sudo port selfupdate
```

```
sudo port upgrade outdated
```

```
sudo port install eiffelstudio
```

Then, open bash_profile
```
cd
nano .bash_profile
```

And Paste (or double check) following codes
```
export ISE_EIFFEL=/Applications/MacPorts/Eiffel_18.11
export ISE_PLATFORM=macosx-x86-64
export PATH=$PATH:$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin
```

Also make sure if MATHMODEL is properly set.
If everything is good,
```
source .bash_profile
```

Then, open estudio
```
estudio &
```

Since the error mentioned about gtk, let's have it once again.
```
sudo port install gtk2
```

And this is optional but nah, lets just have it.
```
sudo port install gtk-chtheme
```

Try gtk-chtheme. It's theming.
```
gtk-chtheme
```
