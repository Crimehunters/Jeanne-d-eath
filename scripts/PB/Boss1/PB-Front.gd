extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var FOG_MOVEMENT = -40
var CLOUD_MOVEMENT = -30
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$L4.motion_offset.x += CLOUD_MOVEMENT * delta
	$Fog.motion_offset.x += FOG_MOVEMENT * delta
