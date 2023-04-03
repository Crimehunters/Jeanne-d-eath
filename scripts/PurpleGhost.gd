extends KinematicBody2D


var target
var init_position
var direction = Vector2.ZERO
var speed = 60
var hp = 10
var dmg = 0.4
var plyFacestate

enum state {SUMMON, WALK, EXPLODED}
onready var ghoststate = state.SUMMON

var skillTime = 10

var TargetExplodeAry = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$HP.value = hp
	
	if(get_parent().has_node("Player")):
		target = get_parent().get_node("Player").position
	else: queue_free()
	
	init_position = get_parent().get_node("Boss").position
	position = init_position
	self.set_process(false)
	$AnimationPlayer.play("Summon")
	plyFacestate = get_parent().get_node("Player").charFaceState
	
func _process(delta):
	$HP.value = hp
	## Update position
	if(get_parent().has_node("Player")):
		target = get_parent().get_node("Player").position
	else: queue_free()
	
	if hp <= 0: queue_free()
	if(skillTime > 0): skillTime -= delta
	elif(skillTime <= 0):
		ghoststate = state.EXPLODED
		
	direction = (target - position).normalized()
	
	if(direction.x > 0 and ghoststate == state.WALK):
		$Ghost.flip_h = true
		$AnimationPlayer.play("Walk")
	elif(direction.x <= 0 and ghoststate == state.WALK):
		$Ghost.flip_h = false
		$AnimationPlayer.play("Walk")
	elif(ghoststate == state.EXPLODED):
		$AnimationPlayer.play("Explode")
	
	move_and_slide(speed*direction)
	
func apply_explode():
	for i in TargetExplodeAry:
		if i.name == "Player":
			i.take_dmg_from_boss_skills(dmg, direction, 2000)
			
func wait_explode_finished():
	queue_free()

func wait_summon_finished():
	ghoststate = state.WALK
	self.set_process(true)
	
func _on_HitboxAttack_body_entered(body):
	TargetExplodeAry.append(body)

func _on_HitboxAttack_body_exited(body):
	TargetExplodeAry.remove(TargetExplodeAry.find(body))
	
func on_Player_atk(dmg, atk_dir, charFaceKnockBack):
	hp -= dmg
	$HP.value = hp
	match(charFaceKnockBack):
		plyFacestate.LEFT: move_and_slide(Vector2.LEFT*5000)
		plyFacestate.RIGHT: move_and_slide(Vector2.RIGHT*5000)
