extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	$CenterContainer/VBoxContainer/ButtonBox/Buttons/Back.disabled = true
	PlayerInfo.selectedMode = PlayerInfo.modes.PRACTICE
	if(!get_parent().get_node("FX").playing):
		get_parent().get_node("FX").play()

func _on_Back_pressed():
	queue_free()
