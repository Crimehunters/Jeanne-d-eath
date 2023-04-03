extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HP.max_value = 3
	$HP.min_value = 0
	
func _process(delta):
	pass
	



func _on_Player_hit(dmg):
	$HP.value -= dmg
