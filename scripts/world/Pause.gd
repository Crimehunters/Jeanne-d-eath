extends Control


var is_paused = false setget paused_effect

func paused_effect(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = is_paused

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if not (get_parent().has_node("Defeated") or get_parent().has_node("Victory")):
			self.is_paused = !is_paused
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Resumebtn_pressed():
	self.is_paused = false

func _on_BacktoMenubtn_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")
