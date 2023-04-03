extends Control

signal use()
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_skillkey()
	_update_skill_count()
	_update_skill_count_banner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_skill_count()
	_update_skill_count_banner()

func _input(event):
	if(Input.is_action_just_pressed("SK1")):
		SkillPool.use(PlayerInfo.SkillKeys[0], "Player")
	elif(Input.is_action_just_pressed("SK2")):
		SkillPool.use(PlayerInfo.SkillKeys[1], "Player")
	elif(Input.is_action_just_pressed("SK3")):
		SkillPool.use(PlayerInfo.SkillKeys[2], "Player")

func _update_skill_count():
	if(PlayerInfo.SkillKeys[0] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[0]].type != "Passive"):
		$SkillSlotContainer/S1/S1Indicator/S1Count.bbcode_text = "[center][b]" + str(SkillPool.pool[PlayerInfo.SkillKeys[0]].current_use_count)
	elif(PlayerInfo.SkillKeys[0] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[0]].type == "Passive"):
		$SkillSlotContainer/S1/S1Indicator/S1Count.bbcode_text = "[center][b] P"
		
	if(PlayerInfo.SkillKeys[1] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[1]].type != "Passive"):
		$SkillSlotContainer/S2/S2Indicator/S2Count.bbcode_text = "[center][b]" + str(SkillPool.pool[PlayerInfo.SkillKeys[1]].current_use_count)
	elif(PlayerInfo.SkillKeys[1] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[1]].type == "Passive"):
		$SkillSlotContainer/S2/S2Indicator/S2Count.bbcode_text = "[center][b] P"
		
	if(PlayerInfo.SkillKeys[2] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[2]].type != "Passive"):
		$SkillSlotContainer/S3/S3Indicator/S3Count.bbcode_text = "[center][b]" + str(SkillPool.pool[PlayerInfo.SkillKeys[2]].current_use_count)
	elif(PlayerInfo.SkillKeys[2] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[2]].type == "Passive"):
		$SkillSlotContainer/S3/S3Indicator/S3Count.bbcode_text = "[center][b] P"

func _update_skill_count_banner():
	# Update Skill count banner
	if(PlayerInfo.SkillKeys[0] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[0]].current_use_count > 0):
		$SkillSlotContainer/S1/S1Indicator.texture = preload("res://sprites/skills/skill_counter_remains.png")
	elif(PlayerInfo.SkillKeys[0] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[0]].type == "Passive"):
		$SkillSlotContainer/S1/S1Indicator.texture = preload("res://sprites/skills/skill_counter_passive.png")
	else: $SkillSlotContainer/S1/S1Indicator.texture = preload("res://sprites/skills/skill_counter_empty.png")
	
	if(PlayerInfo.SkillKeys[1] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[1]].current_use_count > 0):
		$SkillSlotContainer/S2/S2Indicator.texture = preload("res://sprites/skills/skill_counter_remains.png")
	elif(PlayerInfo.SkillKeys[1] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[1]].type == "Passive"):
		$SkillSlotContainer/S2/S2Indicator.texture = preload("res://sprites/skills/skill_counter_passive.png")
	else: $SkillSlotContainer/S2/S2Indicator.texture = preload("res://sprites/skills/skill_counter_empty.png")
	
	if(PlayerInfo.SkillKeys[2] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[2]].current_use_count > 0):
		$SkillSlotContainer/S3/S3Indicator.texture = preload("res://sprites/skills/skill_counter_remains.png")
	elif(PlayerInfo.SkillKeys[2] != 0 and SkillPool.pool[PlayerInfo.SkillKeys[2]].type == "Passive"):
		$SkillSlotContainer/S3/S3Indicator.texture = preload("res://sprites/skills/skill_counter_passive.png")
	else: $SkillSlotContainer/S3/S3Indicator.texture = preload("res://sprites/skills/skill_counter_empty.png")

func _update_skillkey():
	## Update Frame
	if(SkillPool.pool[PlayerInfo.SkillKeys[0]].type == "Passive"): 
		$SkillSlotContainer/S1.texture_normal = load("res://sprites/skills/SkillFrame_passive.png")
	else: $SkillSlotContainer/S1.texture_normal = load("res://sprites/skills/SkillFrame.png")
	
	if(SkillPool.pool[PlayerInfo.SkillKeys[1]].type == "Passive"): 
		$SkillSlotContainer/S2.texture_normal = load("res://sprites/skills/SkillFrame_passive.png")
	else: $SkillSlotContainer/S2.texture_normal = load("res://sprites/skills/SkillFrame.png")
	
	if(SkillPool.pool[PlayerInfo.SkillKeys[2]].type == "Passive"): 
		$SkillSlotContainer/S3.texture_normal = load("res://sprites/skills/SkillFrame_passive.png")
	else: $SkillSlotContainer/S3.texture_normal = load("res://sprites/skills/SkillFrame.png")
	
	# Update Skill pic.
	$SkillSlotContainer/S1/S1Texture.texture = SkillPool.pool[PlayerInfo.SkillKeys[0]].icon_texture
	$SkillSlotContainer/S2/S2Texture.texture = SkillPool.pool[PlayerInfo.SkillKeys[1]].icon_texture
	$SkillSlotContainer/S3/S3Texture.texture = SkillPool.pool[PlayerInfo.SkillKeys[2]].icon_texture

func _on_SelectionUI_changeskill(aplypos, skillkey):
	_update_skillkey()
	pass # Replace with function body.
