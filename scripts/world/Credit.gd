extends Control


var waitTime = 3
var inputBlocker = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	if(PlayerInfo.selectedMode == PlayerInfo.modes.NORMAL):
		PlayerInfo.static_totaltime = PlayerInfo.totaltime
		var hr = int(PlayerInfo.totaltime/3600.0)
		var minutes = int(PlayerInfo.totaltime/60.0)%60
		var seconds = fmod(PlayerInfo.totaltime,60.0)
		var time = "%02d:%02d:%05.2f" % [hr, minutes, seconds]
		
		$CenterContainer/VBoxContainer/Credit.get_v_scroll().value = 0
		$CenterContainer/VBoxContainer/TotalTime.bbcode_text = "[center]" + "Total time " + time
	else: $CenterContainer/VBoxContainer/TotalTime.bbcode_text = "[center]" + "DEATH COUNT: " + str(PlayerInfo.death_count)
		
func _process(delta):
	if(inputBlocker > 0): inputBlocker -= delta
	if (waitTime > 0): waitTime -= delta
	else:
		$CenterContainer/VBoxContainer/Credit.get_v_scroll().value += 0.5
	
func _on_BackToMenu_pressed():
	if(inputBlocker <= 0):
		get_tree().change_scene("res://scenes/menu/MainMenu.tscn")
