extends Control

func _ready():
	## Reload save every main menu scene to reset skills obtained from practice mode##
	SkillPool.check_saved_data()
	SkillPool.load_save()
	#############################

	$CenterContainer/VBoxContainer/Name.modulate.a = 0

func _process(delta):
	$CenterContainer/VBoxContainer/Name.modulate.a += 0.005
	
func _on_Start_pressed():
	PlayerInfo.selectedMode = PlayerInfo.modes.NORMAL
	if(!$FX.playing):
		$FX.play()

func _on_Exit_pressed():
	get_tree().quit()

func _on_FX_finished():
	if(SkillPool.data_state == SkillPool.states.LOAD):
		PlayerInfo.full_reset()
		SkillPool.reset()
	elif(SkillPool.data_state == SkillPool.states.NEW):
		PlayerInfo.full_reset()
		SkillPool.full_reset()
		
	get_tree().change_scene("res://scenes/SkillSelection.tscn")
	## Start Timer
	PlayerInfo.startTimer()

func _on_ViewControl_pressed():
	$CenterContainer.visible = false
	$ControlMap.open_effect(true)
	$ClearSave.hide()

func _on_ClearSave_pressed():
	var dir = Directory.new()
	if(dir.file_exists("user://savegame.save")):
		dir.remove("user://savegame.save")
		$ClearSave.text = "Save Deleted"
	else: $ClearSave.text = "No Save Found"
	
	## Reload and reset save data
	SkillPool.check_saved_data()
	SkillPool.load_save()

func _on_Practice_pressed():
	var prtc_ins = load("res://scenes/menu/PracticePopup.tscn").instance()
	get_node(".").add_child(prtc_ins)
