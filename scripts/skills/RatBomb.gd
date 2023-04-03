extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var target
var init_position
var direction = Vector2.ZERO
var speed = 180
var hp = 5
enum state {RUN, ATTACK, EXPLODED}
onready var micestate = state.RUN

var attackTick = 1
var skillTime = 8

var TargetAttackAry = []
var TargetExplodeAry = []

var caller
# Called when the node enters the scene tree for the first time.
func _ready():
	$HP.value = hp
	
	if(caller == "Player"):
		if(get_parent().has_node("Boss")): target = get_parent().get_node("Boss").position
		else: queue_free()
		
		if(get_parent().has_node("Player")): init_position = get_parent().get_node("Player").position
		else: queue_free()
	elif(caller == "Boss"):
		if(get_parent().has_node("Player")): target = get_parent().get_node("Player").position
		else: queue_free()
		
		if(get_parent().has_node("Boss")): init_position = get_parent().get_node("Boss").position
		else: queue_free()
		
	position = init_position
	$RatbombExplode.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HP.value = hp
	if(hp <= 0): queue_free()
	## Update direction
	if(caller == "Player"):
		if(get_parent().has_node("Boss")): target = get_parent().get_node("Boss").position
		else: queue_free()
	elif(caller == "Boss"):
		if(get_parent().has_node("Player")): target = get_parent().get_node("Player").position
		else: queue_free()
	
	## Skill Timeout
	if(skillTime > 0): skillTime -= delta
	elif(skillTime <= 0):
		micestate = state.EXPLODED
		$Ratbomb.hide()
		$RatbombExplode.show()
		$AnimationPlayer.play("Explode")
	
	# Update Attack rate	
	if(attackTick > 0 and skillTime > 0): attackTick -= delta
	elif(attackTick <= 0 and !TargetAttackAry.empty() and skillTime > 0): 
		micestate = state.ATTACK
		$AnimationPlayer.play("Attack")
	
	direction = (target - position).normalized()
	
	if(direction.x >= 0 and micestate == state.RUN and skillTime > 0):
		$Ratbomb.flip_h = true
		$Ratbomb.position.x = 0
		$HitboxAttack.rotation_degrees = 180
		$AnimationPlayer.play("Walk")
	elif(direction.x < 0 and micestate == state.RUN and skillTime > 0):
		$Ratbomb.flip_h = false
		$Ratbomb.position.x = 0
		$HitboxAttack.rotation_degrees = 0
		$AnimationPlayer.play("Walk")
	elif(micestate == state.EXPLODED):
		$AnimationPlayer.play("Explode")
			
	move_and_slide(speed*direction)

func apply_atk_hitbox():
	if(caller == "Player"):
		for i in TargetAttackAry:
			if(i.name == "Boss"):
				i.take_dmg_from_skill(SkillPool.ratBomb.dmg, direction, 5000)
				break
				
	elif(caller == "Boss"):
		for i in TargetAttackAry:
			if(i.name == "Player"):
				i.take_dmg_from_boss_skills(0.5, direction, 5000)
				break

func wait_attack_finished():
	attackTick = 1
	if(skillTime > 0): micestate = state.RUN
	
func apply_explode_hitbox():
	if(caller == "Player"):
		for i in TargetExplodeAry:
			if(i.name == "Boss"):
				i.take_dmg_from_skill(5, direction, 6000)
	elif(caller == "Boss"):
		for i in TargetExplodeAry:
			if(i.name == "Player"):
				i.take_dmg_from_boss_skills(1, direction, 6000)
	
func wait_explode_finished():
	queue_free()

func _on_HitboxAttack_body_entered(body):
	if(caller == "Boss"):
		if (body.name == "Player"):
			TargetAttackAry.append(body)
	elif(caller == "Player"):
		if (body.name == "Boss"):
			TargetAttackAry.append(body)

func _on_HitboxAttack_body_exited(body):
	TargetAttackAry.remove(TargetAttackAry.find(body))

func _on_HitboxExplode_body_entered(body):
	TargetExplodeAry.append(body)

func _on_HitboxExplode_body_exited(body):
	TargetExplodeAry.remove(TargetExplodeAry.find(body))
	
func on_Player_atk(dmg, atk_dir, charFaceKnockBack):
	hp -= dmg
	$HP.value = hp
