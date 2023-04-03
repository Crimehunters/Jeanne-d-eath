extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if(event.is_action_pressed("instant_kill") and PlayerInfo.selectedMode == PlayerInfo.modes.PRACTICE):
		if(get_node("MainSort/Characters/").has_node("Boss")):
			get_node("MainSort/Characters/Boss").queue_free()
			_on_Boss_defeated()

func _on_Boss_defeated():
	PlayerInfo.stopTimer()
	for i in get_node("MainSort/Characters").get_children():
		get_node("MainSort/Characters").remove_child(i)
	
	var victory_node = load("res://scenes/menu/Victory.tscn").instance()
	get_node("UI").add_child(victory_node)
	
func _on_Player_defeated():
	PlayerInfo.stopTimer()
	for i in get_node("MainSort/Characters").get_children():
		get_node("MainSort/Characters").remove_child(i)
		
	var defeated_node = load("res://scenes/menu/Defeated.tscn").instance()
	get_node("UI").add_child(defeated_node)
