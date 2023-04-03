extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var randPool : Array
var rng_int
var current_selection_pos
var current_apply_pos

# CHOOSESK: Choosing skill
# APPLYSK: Apply chosen skill
# READY: Proceed to game
enum system_states {CHOOSESK, APPLYSK, READY}
var state
var excludedSkills # Exclude skill that already assigned not to be RNG again

signal changeskill(aplypos, skillkey)
# Called when the node enters the scene tree for the first time.
func _ready():
	state = system_states.CHOOSESK
	$Start.hide()
	
	## RNG Skill key ##
	rng_int = RandomNumberGenerator.new()
	rng_int.seed = hash("Jeanne")
	var tmp_skillpool_key = SkillPool.availableSkill.keys()
	print("Tmp: ", tmp_skillpool_key)
	excludedSkills = PlayerInfo.SkillKeys
	
	for i in 3:
		rng_int.randomize()
		var rand_key = rng_int.randi_range(1, tmp_skillpool_key.size() - 1)
		randPool.append(tmp_skillpool_key[rand_key])
		tmp_skillpool_key.remove(rand_key)
	############################################
	## Add obtained skill to selection pool ##
	if(!randPool.has(PlayerInfo.current_obtained_skill_key) and PlayerInfo.current_obtained_skill_key != 0):
		randPool[0] = PlayerInfo.current_obtained_skill_key
	
	print("Pool", randPool)
	$SkillPoolContainer/SkillFrame/SkillSelect.texture = SkillPool.pool[randPool[0]].icon_texture
	$SkillDetail/SkillTitle.bbcode_text = "[center][b]" + SkillPool.pool[randPool[0]].title
	$SkillDetail/SkillDescp.bbcode_text = SkillPool.pool[randPool[0]].description
	current_selection_pos = 0
	current_apply_pos = 0
	#print("FinishedPOS ", current_selection_pos, "\tData: ", randPool[current_selection_pos])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Check if there are the same skills assigned, set usage count to multiplied of assigned skills
func multiply_duplicated_usecount():
	for i in PlayerInfo.SkillKeys:
		SkillPool.pool[i].current_use_count = PlayerInfo.SkillKeys.count(i) * SkillPool.pool[i].count

func _input(event):
	
	# SPACE/ENTER events
	if(Input.is_action_pressed("ui_accept") and state == system_states.CHOOSESK):
		state = system_states.APPLYSK
		var AplyArrow = TextureRect.new()
		AplyArrow.texture = load("res://sprites/skills/apply_selection_arrow.png")
		AplyArrow.rect_position.x = 277
		AplyArrow.rect_position.y = 420
		$SkillSlot.add_child(AplyArrow)
		
	elif(Input.is_action_pressed("ui_accept") and state == system_states.APPLYSK):
		PlayerInfo.SkillKeys[current_apply_pos] = randPool[current_selection_pos]
		$SkillSlot._update_skillkey()
		state = system_states.READY
		$Start.show()
		
	elif(Input.is_action_pressed("ui_accept") and state == system_states.READY):
		multiply_duplicated_usecount()
		queue_free()
		#get_tree().change_scene("res://Boss_" + str(PlayerInfo.current_stage) + "_world.tscn")
		## Getting to lore scene on each boss ##
		PlayerInfo.stopTimer()
		get_tree().change_scene("res://scenes/menu/Lore_" + str(PlayerInfo.current_stage) + ".tscn")
	##################################################################################
	
	# L-Key events
	if(Input.is_action_pressed("ui_left") and state == system_states.CHOOSESK):
		if (current_selection_pos == 0): current_selection_pos = randPool.size() - 1
		else: current_selection_pos -= 1
		
		#print("POS ", current_selection_pos, "\tData: ", randPool[current_selection_pos])
		$SkillPoolContainer/SkillFrame/SkillSelect.texture = SkillPool.pool[randPool[current_selection_pos]].icon_texture
		$SkillDetail/SkillTitle.bbcode_text = "[center][b]" + SkillPool.pool[randPool[current_selection_pos]].title
		$SkillDetail/SkillDescp.bbcode_text = SkillPool.pool[randPool[current_selection_pos]].description
	elif(Input.is_action_pressed("ui_left") and state == system_states.APPLYSK):
		if (current_apply_pos == 0): 
			current_apply_pos = 2
			$SkillSlot.get_child(1).rect_position.x += 3*178
		else: current_apply_pos -= 1
		
		#print("APPLY POS ", current_apply_pos, "\tData: ", randPool[current_selection_pos])
		$SkillSlot.get_child(1).rect_position.x -= 178

	########################################
	
	# R-key events 
	if(Input.is_action_pressed("ui_right") and state == system_states.CHOOSESK):
		if (current_selection_pos == randPool.size() - 1): current_selection_pos = 0
		else: current_selection_pos += 1
		
		#print("POS ", current_selection_pos, "\tData: ", randPool[current_selection_pos])
		$SkillPoolContainer/SkillFrame/SkillSelect.texture = SkillPool.pool[randPool[current_selection_pos]].icon_texture
		$SkillDetail/SkillTitle.bbcode_text = "[center][b]" + SkillPool.pool[randPool[current_selection_pos]].title
		$SkillDetail/SkillDescp.bbcode_text = SkillPool.pool[randPool[current_selection_pos]].description
		
	elif(Input.is_action_pressed("ui_right") and state == system_states.APPLYSK):
		if (current_apply_pos == 2): 
			current_apply_pos = 0
			$SkillSlot.get_child(1).rect_position.x -= 3*178
		else: current_apply_pos += 1
		
		#print("APPLY POS ", current_apply_pos, "\tData: ", randPool[current_selection_pos])
		$SkillSlot.get_child(1).rect_position.x += 178
	###########################################
