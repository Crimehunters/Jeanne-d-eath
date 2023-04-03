extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target
var init_position
var direction = Vector2.ZERO
var speed = 150
var skillTime = 5
enum state {READY, EXPLODED}
onready var ballstate = state.READY

func _ready():
	if(get_parent().has_node("Boss")):
		target = get_parent().get_node("Boss").position
	else: queue_free()
	
	init_position = get_parent().get_node("Player").position
	position = init_position
	#print("Boss Pos:", target)
	#print("Ply Pos:", init_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## Skill Timeout
	if(skillTime > 0): skillTime -= delta
	elif(skillTime <= 0): queue_free()
	
	
	if(direction.x >= 0 and ballstate == state.READY):
		if($AnimationPlayer.current_animation != "FlowRIGHT"): $AnimationPlayer.play("FlowRIGHT")
	elif(direction.x < 0 and ballstate == state.READY):
		if($AnimationPlayer.current_animation != "FlowLEFT"): $AnimationPlayer.play("FlowLEFT")
	elif(ballstate == state.EXPLODED):
		$Trackingball.hide()
		$TrackingballHit.show()
		if($AnimationPlayer.current_animation != "Explode"):
			$AnimationPlayer.play("Explode")
			
			
	if(get_parent().has_node("Boss")):
		target = get_parent().get_node("Boss").position
	else: queue_free()
	
	direction = (target - position).normalized()
	move_and_slide(speed*direction)

func _on_Hitbox_body_entered(body):
	#print(body.name)
	$AnimationPlayer.stop()
	if(ballstate == state.READY):	
		if(body.name == "Boss"):
			body.take_dmg_from_skill(SkillPool.trackingBall.dmg, direction, 2000)
			ballstate = state.EXPLODED

func wait_explode_finished():
	#print("Freed")
	queue_free()
