extends Node2D


var init_position
var backup_default_speed
var skillTime = 20
var damegeTick = 1
var target
var knockbackVector
var caller

var TargetAry = []
# Called when the node enters the scene tree for the first time.
func _ready():
	if(caller == "Player"):
		init_position = get_parent().get_node("Player").position
		position = init_position
		if(get_parent().has_node("Boss")): target = get_parent().get_node("Boss").position
		else: queue_free()
		
	elif(caller == "Boss"):
		init_position = get_parent().get_node("Boss").position
		position = init_position
		if(get_parent().has_node("Player")): target = get_parent().get_node("Player").position
		else: queue_free()
	
	knockbackVector = Vector2.ZERO
	$AnimationPlayer.play("Active")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## Update direction
	if(caller == "Player"):
		if(get_parent().has_node("Boss")): target = get_parent().get_node("Boss").position
		else: queue_free()
		
	elif(caller == "Boss"):
		if(get_parent().has_node("Player")): target = get_parent().get_node("Player").position
		else: queue_free()
	
	knockbackVector = (target - position).normalized()
	
	if(skillTime > 0): skillTime -= delta
	elif(skillTime <= 0):
		queue_free()
		
	if(damegeTick > 0): damegeTick -= delta
	elif(damegeTick <= 0):
		damegeTick = 1
		apply_hitbox()
		
func apply_hitbox():
	if(caller == "Player"):
		for i in TargetAry:
			if(i.name == "Boss"):
				i.take_dmg_from_skill(SkillPool.suffocation.dmg, knockbackVector, 1000)
	elif(caller == "Boss"):
		for i in TargetAry:
			if(i.name == "Player"):
				i.take_dmg_from_boss_skills(0.5, knockbackVector, 1000)

func _on_HitboxEffect_body_entered(body):
	TargetAry.append(body)
	if(caller == "Player"):
		if(body.name == "Boss"):
			backup_default_speed = body.static_boss_speed
			body.default_boss_speed = 0.6*backup_default_speed
	elif(caller == "Boss"):
		if(body.name == "Player"):
			backup_default_speed = body.static_player_speed
			body.default_player_speed = 0.6*backup_default_speed
	
func _on_HitboxEffect_body_exited(body):	
	if(caller == "Player"):
		if(body.name == "Boss"):
			body.default_boss_speed = backup_default_speed
	elif(caller == "Boss"):
		if(body.name == "Player"):
			body.default_player_speed = backup_default_speed
			
	TargetAry.remove(TargetAry.find(body))
	
