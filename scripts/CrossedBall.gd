extends KinematicBody2D

var target
var init_position
var direction = Vector2.ZERO
var speed = 90
var dmg = 0.2
var hp = 10
var skillTime = 8
# Called when the node enters the scene tree for the first time.
func _ready():
	if(get_parent().has_node("Player")):
		target = get_parent().get_node("Player").position
	else: queue_free()
	
	init_position = get_parent().get_node("Boss").position
	position = init_position
	
	if(direction.x > 0): $Crossedball.flip_h = false
	elif(direction.x <= 0): $Crossedball.flip_h = true
	
	$AnimationPlayer.play("Active")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0: queue_free()
	## Update direction
	if(get_parent().has_node("Player")):
		target = get_parent().get_node("Player").position
	else: queue_free()
	
	direction = (target - position).normalized()
	
	if(skillTime > 0): skillTime -= delta
	elif(skillTime <= 0): queue_free()
	
	move_and_slide(speed*direction)
	
func _on_HitboxAttack_body_entered(body):
	if body.name == "Player":
		#body.take_dmg_from_boss_skills(dmg, direction, 2000)
		body._on_Boss_atk(dmg, direction, 300)
		queue_free()
		
func on_Player_atk(dmg, atk_dir, charFaceKnockBack):
	hp -= dmg
	$HP.value = hp
