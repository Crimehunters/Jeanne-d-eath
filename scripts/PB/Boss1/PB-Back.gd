extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var L3CloudSPD = -10
var L4CloudSPD = -30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$L3.motion_offset.x += L3CloudSPD * delta
	$L4.motion_offset.x += L4CloudSPD * delta
