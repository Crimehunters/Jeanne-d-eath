extends KinematicBody2D

## Workaround fix for Suffocation skill
var static_boss_speed = 100
#####

export var default_boss_speed = 100
var speed
export var default_boss_hp = 90
var hp
enum CharFace{Right, Left}
var attacking = false
var direction = Vector2.ZERO
export var default_atk_cooldown = 3
var atk_cooldown
var summon_cooldown = default_atk_cooldown*1.25
var ply
var TargetHitboxAry = []
var TargetSummonAry = []

enum charFaceState {
	LEFT = 0, 
	RIGHT = 1
}

enum states {
	IDLE,
	WALK,
	DASH,
	ATK,
}
var BossFace
var Animate_state


signal atk(dmg, atk_dir, charFaceState)
signal defeated()

##### For AI ######
# Awareness of Player HP, Player direction, Boss atk cooldown, Boss skill cd
# 	- Value range between 0 [<0 is deffensive, >0 is offensive]
var awareness = [0,0,0,0,0]
var dash_cd = 5
var skill_cd = 6
var linear_bar = 0
enum ai_states {OFFENCE,DEFFENCE}
onready var ai_state = ai_states.OFFENCE
####################

func _ready():
	ply = Vector2.ZERO
	atk_cooldown = default_atk_cooldown
	speed = default_boss_speed
	hp = default_boss_hp
	$HP.max_value = default_boss_hp
	$HP.min_value = 0

func awareness_calc():
	for i in awareness.size():
		match i:
			0: ## Player HP awareness
				if(PlayerInfo.currentHP >= 3):
					awareness[i] = 0
				elif(PlayerInfo.currentHP == 2):
					awareness[i] = 3
				elif(PlayerInfo.currentHP == 1):
					awareness[i] = 10
			1: ## Player Direction
				var distance_between = sqrt(pow(position.x - ply.x,2) + pow(position.y - ply.y,2))
				#print(distance_between)
				if(distance_between > 500):
					awareness[i] = (distance_between/50) - 10
				else: awareness[i] = 0 - (distance_between/500)
			2: ## Atk cd
				if(atk_cooldown > 0): awareness[i] = 0 - atk_cooldown
				else: awareness[i] = 5
			3: ## Boss skill CD
				if(skill_cd >  0): awareness[i] = 0 - skill_cd
				else: awareness[i] = skill_cd+2
			4: ## Boss HP
				if(hp <= 20): awareness[i] = 8
				elif(hp <= 40): awareness[i] = -5
				elif(hp <= 60): awareness[i] = 0
				elif(hp <= 80): awareness[i] = 5
				elif(hp <= 100): awareness[i] = 10
				
func apply_ability(delta):
	if(skill_cd > 0): skill_cd -= delta
	else:
		if(ai_state == ai_states.OFFENCE): SkillPool.use(12, "Boss")
		elif(ai_state == ai_states.DEFFENCE): SkillPool.use(7, "Boss")
		skill_cd = 6
		
	if(dash_cd > 0): dash_cd -= delta
	else:
		if(ai_state == ai_states.OFFENCE): move_and_slide(direction.normalized()*5000)
		else:
			var distance_between = sqrt(pow(position.x - ply.x,2) + pow(position.y - ply.y,2))
			if(distance_between < 200): move_and_slide(-1*direction.normalized()*5000)
		dash_cd = 5
	
func blending_awareness():
	var pos_sum = 0
	var pos_size = 0
	var neg_sum = 0
	var neg_size = 0
	
	for i in awareness:
		if(i >= 0):
			pos_sum += i
			pos_size += 1
		else:
			neg_sum += i
			neg_size += 1
	
	if(pos_size == 0): linear_bar = neg_sum / neg_size
	elif(neg_size == 0): linear_bar = pos_sum / pos_size
	elif(pos_size == 0 and neg_size == 0): linear_bar = 0
	else: 
		linear_bar = (pos_sum / pos_size) + (neg_sum / neg_size)
	
	if(linear_bar > 0): ai_state = ai_states.OFFENCE
	else: ai_state = ai_states.DEFFENCE

func _process(delta):
	######### AI Calculating ############
	awareness_calc()
	blending_awareness()
	apply_ability(delta)
	print(linear_bar, "\t", ai_state)
	#####################################

	# HP Check if it's 0 then do something
	if hp <= 0: 
		queue_free()
		emit_signal("defeated")
	
	# Normal Attack Cooldown
	if atk_cooldown <= 0: 
		atk_cooldown = 0
	elif atk_cooldown <= default_atk_cooldown:
		atk_cooldown -= delta
		
	# Normal Attack Cooldown
	if summon_cooldown > 0: summon_cooldown -= delta
	elif summon_cooldown <= default_atk_cooldown*1.5:
		for i in TargetSummonAry:
			if (summon_cooldown <= 0 and i.name == "Player"):
				var purpleghost_ins = load("res://scenes/BossNA/PurpleGhost.tscn").instance()
				get_parent().add_child(purpleghost_ins)
				summon_cooldown = default_atk_cooldown*1.5
				break
				
	# Get player position and create direction vector for boss to follow
	direction = (ply - position).normalized()
	
	if((Animate_state == states.IDLE or Animate_state == states.WALK) and Animate_state != states.DASH):
		speed = default_boss_speed
	
	# Boss1 face direction
	if direction.x > 0: 
		BossFace = charFaceState.RIGHT
		$BossMain.flip_h = true
		$AtkArea.rotation_degrees = 180
	elif direction.x < 0: 
		BossFace = charFaceState.LEFT
		$BossMain.flip_h = false
		$AtkArea.rotation_degrees = 0
	
	# Boss1 input state
	if(direction == Vector2.ZERO and Animate_state != states.ATK and Animate_state != states.DASH): Animate_state = states.IDLE
	elif(direction != Vector2.ZERO and Animate_state != states.ATK and Animate_state != states.DASH): Animate_state = states.WALK
	
	if (direction == Vector2.ZERO and Animate_state == states.IDLE):
		$AnimationPlayer.play("Idle")
	elif(direction != Vector2.ZERO and Animate_state == states.WALK):
		$AnimationPlayer.play("Run")
			
	for i in TargetHitboxAry:	
		if (atk_cooldown <= 0 and i.name == "Player"):
			Animate_state = states.ATK
			$AnimationPlayer.play("Atk")
			speed = 20
			break
			


	var collision = move_and_slide(speed*direction)
	#print("HitboxAry", TargetHitboxAry)

func _on_Player_atk(dmg, knockback_vector, charFaceKnockBack):
	#print("Getting hit!")
	hp -= dmg
	$HP.value = hp
	match(charFaceKnockBack):
		charFaceState.LEFT: move_and_slide(Vector2.LEFT*5000)
		charFaceState.RIGHT: move_and_slide(Vector2.RIGHT*5000)

func wait_atk_finished():
	speed = default_boss_speed
	atk_cooldown = default_atk_cooldown
	if direction == Vector2.ZERO:
		Animate_state = states.IDLE
	elif direction != Vector2.ZERO:
		Animate_state = states.WALK
	
func _on_AtkArea_body_entered(body):
	#print("Player is in ATK shape area")
	TargetHitboxAry.append(body)

func dmg_atk():
	if TargetHitboxAry.empty(): pass
	for i in TargetHitboxAry:
		if (i.name == "Player" and atk_cooldown <= 0):
			emit_signal("atk", 1, direction, BossFace)

func _on_AtkArea_body_exited(body):
	TargetHitboxAry.remove(TargetHitboxAry.find(body))


func _on_Player_position_broadcast(pos):
	ply = pos

### For skill that player call, boss can take damage from this with "body" object
func take_dmg_from_skill(dmg, Knockbackdir, knockbackvalue):
	hp -= dmg;
	$HP.value = hp
	move_and_slide(Knockbackdir*knockbackvalue)

func _on_SummonArea_body_entered(body):
	TargetSummonAry.append(body)

func _on_SummonArea_body_exited(body):
	TargetSummonAry.remove(TargetSummonAry.find(body))
