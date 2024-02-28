extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# This Chart will plot 3 different functions
var f1: Function

func _ready():
	# Let's create our @x values
	var x: PackedFloat32Array = [0,1,2];
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y: Array = [0,1,2];
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#daedfa")
	cp.colors.background = Color("daedfa")
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color("#000000")
	cp.draw_bounding_box = false
	cp.x_label = "Time"
	cp.y_label = "Accuracy"
	cp.x_scale = 1
	cp.y_scale = 1
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Pressure", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		# Let's also provide a dictionary of configuration parameters for this specific function.
		{ 
			color = Color("#36a2eb"), 		# The color associated to this function
			marker = Function.Marker.CIRCLE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE, 		# This defines what kind of plotting will be used, 
											# in this case it will be a Linear Chart.
			interpolation = Function.Interpolation.STAIR	# Interpolation mode, only used for 
															# Line Charts and Area Charts.
		}
	)
	
	# Now let's plot our data
	chart.plot([f1], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)
