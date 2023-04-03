extends Control

var is_open = false

func open_effect(value):
	is_open = value
	get_tree().paused = is_open
	visible = is_open
	print(visible)
	
func _ready():
	visible = is_open

func _on_ExitBtn_pressed():
	if(get_tree().get_root().has_node("MainMenu")):
		get_tree().get_root().get_node("MainMenu/CenterContainer").visible = true
		get_tree().get_root().get_node("MainMenu/ClearSave").show()
	get_tree().paused = false
	self.visible = false
