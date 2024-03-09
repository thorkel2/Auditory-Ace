extends Control

@onready var chart: Chart = $VBoxContainer/Chart
@onready var wordlist = Globals.wordlist if Globals.wordlist else "All"
@onready var entries = Database.searchEntries("All","All",wordlist,"All")
@onready var score = [0];
@onready var date = [0];
@onready var result_array = [];

var cp: ChartProperties = ChartProperties.new()
var f1: Function
func create_array(n: int) -> Array:
	var result_array = []
	for i in range(1, n + 1):
		result_array.append(i)
	return result_array

func _ready():
	if(entries[0]):
		var temp = create_array(entries[0].size())
		date.append_array(temp)
	if(entries[1]):
		score.append_array(entries[1])
	var x: Array = date
	var y: Array = score
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	cp.colors.frame = Color("#daedfa")
	cp.colors.background = Color("daedfa")
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color("#000000")
	cp.draw_bounding_box = false
	cp.x_scale = 10
	cp.y_scale = 5
	#cp.x_tick_size = 60
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Score Over Time", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		# Let's also provide a dictionary of configuration parameters for this specific function.
		{ 
			color = Color("#004999"), 		# The color associated to this function
			marker = Function.Marker.CIRCLE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE, 		# This defines what kind of plotting will be used, 
											# in this case it will be a Linear Chart.
			interpolation = Function.Interpolation.STAIR	# Interpolation mode, only used for 
															# Line Charts and Area Charts.
		}
	)
	
	# Now let's plot our data
	print(entries)
	print(x)
	print(y)
	chart.plot([f1], cp)

func _on_word_list_dropdown_item_selected(index):
	if(index == 0):
		Globals.wordlist = "All"
	if(index == 1):
		Globals.wordlist = "MvN"
	if(index == 2):
		Globals.wordlist = "SvF"
	if(index == 3):
		Globals.wordlist = "TvP"
	get_tree().change_scene_to_file("res://Scenes/profile.tscn")
