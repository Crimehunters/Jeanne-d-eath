extends Control

var SkillobtainedKey
var inputBlocker = 1.5 ## delay 1 sec. for input prompt
# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/VictoryLabel.percent_visible = 0
	$CenterContainer/VBoxContainer/ObtainableLabel.percent_visible = 0
	
	randomize()
	SkillPool.bossSkill[PlayerInfo.current_stage].shuffle()
	SkillobtainedKey = SkillPool.bossSkill[PlayerInfo.current_stage][0]
	SkillPool.add_obtained_skill(SkillobtainedKey)
	
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/SkillTitle.bbcode_text = "[center][b]" + SkillPool.pool[SkillobtainedKey].title
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/SkillDescp.bbcode_text = SkillPool.pool[SkillobtainedKey].description
	$CenterContainer/VBoxContainer/HBoxContainer/SkillObtainFrame/Skill.texture = SkillPool.pool[SkillobtainedKey].icon_texture
	
	### Save Progress if NORMAL mode is played ##
	if(PlayerInfo.selectedMode == PlayerInfo.modes.NORMAL): PlayerInfo.save_game()
	
func _input(event):
	if(event.is_action_pressed("ui_up")):
		$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/SkillDescp.get_v_scroll().value -= 2
	if(event.is_action_pressed("ui_down")):
		$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/SkillDescp.get_v_scroll().value += 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(inputBlocker > 0): inputBlocker -= delta
	$CenterContainer/VBoxContainer/VictoryLabel.percent_visible += 0.02
	$CenterContainer/VBoxContainer/ObtainableLabel.percent_visible += 0.01

func _on_Continue_pressed():
	if(inputBlocker <= 0):
		PlayerInfo.current_stage += 1
		
		if(PlayerInfo.current_stage > 5):
			get_tree().change_scene("res://scenes/menu/Credit.tscn")
		else:
			PlayerInfo.currentHP += 2
			get_tree().change_scene("res://scenes/SkillSelection.tscn")
			PlayerInfo.reset()
			PlayerInfo.current_obtained_skill_key = SkillobtainedKey
			
			## One more Life to Call
			if(PlayerInfo.SkillKeys.has(5)): PlayerInfo.currentHP += 0.5
			SkillPool.reset()
			
			PlayerInfo.startTimer()

func _on_Exit_pressed():
	PlayerInfo.current_obtained_skill_key = SkillobtainedKey
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")
