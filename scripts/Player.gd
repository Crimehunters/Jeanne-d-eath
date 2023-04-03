extends KinematicBody2D

## Workaround fix for Suffocating skill
var static_player_speed = 150

# Basic movement
export var default_player_speed = 150
var speed = default_player_speed

# dashing movement
export var default_player_dash_cooldown = 1.5
export var default_player_dash_count = 5
export var default_player_dash_speed = 300
export var default_atk_cooldown = 0.25
var dash_cooldown = default_player_dash_cooldown
var dash_count = default_player_dash_count
var stop_dash_cd = true # Set CD to 0 when dash count is full
var atk_cooldown = default_atk_cooldown
var TargetHitboxAry = []

var input = Vector2.ZERO
# iframe
onready var isIFrame = false

func start_col():
	### Collision Layer 3 is for dodging
	self.set_collision_layer_bit(1, false)
	self.set_collision_mask_bit(1, false)
	
func end_col():
	self.set_collision_layer_bit(1, true)
	self.set_collision_mask_bit(1, false)

func start_iframe():
	isIFrame = true
	
func end_iframe():
	isIFrame = false

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

var charFace
var plystate

# Bool for invincible normal attack (For skills)
var invincibleCount = 0

# signal
signal atk(dmg, atk_dir, charFaceKnockBack)
signal hit(dmg)

# broadcasting position to any nodes connected
signal position_broadcast(pos)
signal defeated()

func _ready():
	charFace = charFaceState.RIGHT
	plystate = states.IDLE

func _input(event):
	# Attack and Dash control
	if InputBuffer.is_action_press_buffered("player_atk"):
		if(atk_cooldown <= 0):
			plystate = states.ATK
			speed = 10
			atk_cooldown = default_atk_cooldown
			$AnimationPlayer.play("Attack")
		
	elif Input.is_action_just_pressed("player_dash"):
		if dash_count > 0:
			plystate = states.DASH
			print("Dash!!!")
			$AnimationPlayer.play("Dash")
			speed = default_player_dash_speed
			dash_count -= 1
			stop_dash_cd = false

func _process(delta):
	# Updating
	if PlayerInfo.currentHP <= 0:
		if(PlayerInfo.selectedMode == PlayerInfo.modes.NORMAL):
			emit_signal("defeated")
			queue_free()
		else: PlayerInfo.currentHP += PlayerInfo.health
	
	if(atk_cooldown > 0): atk_cooldown -= delta
	else: atk_cooldown = 0
	#if PlayerInfo.skill_NA_hit == 0: PlayerInfo.reset()
	
	if((plystate == states.IDLE or plystate == states.WALK) and plystate != states.DASH):
		speed = default_player_speed
	dash_update(delta)
	
	# Position broadcast to boss
	emit_signal("position_broadcast", position)
	################################
	
	
	# Player movement vector
	input.x = Input.get_action_strength("move_r") - Input.get_action_strength("move_l")
	input.y = Input.get_action_strength("move_d") - Input.get_action_strength("move_u")
	#########################################
	
	# Player face direction
	if input.x > 0: 
		charFace = charFaceState.RIGHT
		$NewJeanne.flip_h = false
		$NewJeanne.position.x = 5 ## Calibrate sprite pos
		$AttackArea.rotation_degrees = 180
	elif input.x < 0: 
		charFace = charFaceState.LEFT
		$NewJeanne.flip_h = true
		$NewJeanne.position.x = -5 ## Calibrate sprite pos
		$AttackArea.rotation_degrees = 0
	
	# Player input state
	if(input == Vector2.ZERO and plystate != states.ATK and plystate != states.DASH): plystate = states.IDLE
	elif(input != Vector2.ZERO and plystate != states.ATK and plystate != states.DASH): plystate = states.WALK
	# normalized vector (prevent vector value increase over time)
	input = input.normalized()
	
	
	if (input == Vector2.ZERO and plystate == states.IDLE):
		$AnimationPlayer.play("Idle")
	elif(input != Vector2.ZERO and plystate == states.WALK):
		$AnimationPlayer.play("Walk")
	
	#print("TargetArea: ", TargetHitboxAry)
	#print("Dash count: ", dash_count, "\tDash CD: ", dash_cooldown, "\tspeed: ", speed)
	move_and_slide(input*speed)
	pass
	
func dash_update(delta): # Dash system update, it requires delta time to count the cooldown
	if dash_count == default_player_dash_count: # No dash CD if it's full
		stop_dash_cd = true
		dash_cooldown = 0
	if dash_cooldown <= 0 and stop_dash_cd == false: # Has dash CD if it's not full
		dash_cooldown = default_player_dash_cooldown
	elif stop_dash_cd == false:
		dash_cooldown -= delta
		if dash_cooldown <=0 : dash_count += 1

func wait_dash_finished():
	speed = default_player_speed
	if (input == Vector2.ZERO): plystate = states.IDLE
	elif(input != Vector2.ZERO): plystate = states.WALK
	
# Call back track on AnimationPlayer trigger this when attack animation is completely finish -> disable attack animation
func wait_atk_finished():
	speed = default_player_speed
	if (input == Vector2.ZERO): plystate = states.IDLE
	elif(input != Vector2.ZERO): plystate = states.WALK

func attack_gettingHit():
	## For limiting skill buff attack limit
	if(PlayerInfo.skill_NA_hit > 0): PlayerInfo.skill_NA_hit -= 1
	#print("Skill NA count check:", PlayerInfo.skill_NA_hit)
	print("PlyBoxAry:", TargetHitboxAry)
	if TargetHitboxAry.empty(): pass
	for i in TargetHitboxAry:
		if i is KinematicBody2D:
			if(i.name != "Boss"):
				print(i.name)
				i.on_Player_atk(PlayerInfo.current_atkdmg, input, charFace)
			else:
				match(charFace):
					charFaceState.LEFT: emit_signal("atk", PlayerInfo.current_atkdmg, input, charFaceState.LEFT)
					charFaceState.RIGHT: emit_signal("atk", PlayerInfo.current_atkdmg, input, charFaceState.RIGHT)

func _on_AttackArea_body_entered(body):
	if(body != self):
		TargetHitboxAry.append(body)
	#print("BodyAry: ", TargetHitboxAry)
	
	
# Call back when there is area/body entering atk shape
func _on_AttackArea_body_exited(body):
	TargetHitboxAry.remove(TargetHitboxAry.find(body))


# Call back when Player entered boss attack range
func _on_Boss_atk(dmg, atk_dir, charFaceDir):
	## Check Dodge Iframe first
	if(isIFrame): return
	elif(invincibleCount > 0): invincibleCount -= 1
	else:
		emit_signal("hit", dmg)
		#print("Hit is called")
		if charFaceDir:
			move_and_slide(Vector2.RIGHT*6000)
		else:
			move_and_slide(Vector2.LEFT*6000)

## For non-signalable damage from boss NA or skills
func take_dmg_from_boss_skills(dmg, knockbackVector, knockbackValue):
	emit_signal("hit", dmg)
	move_and_slide(knockbackValue*knockbackVector)
