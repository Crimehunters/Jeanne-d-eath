extends Node2D


var backup_default_speed
var skilltime = 8
var facedir
var action
var actionstate
var facestate
var caller
# Called when the node enters the scene tree for the first time.
func _ready():	
	if(caller == "Player"):
		facedir = get_parent().charFace
		facestate = get_parent().charFaceState
		action = get_parent().plystate
		actionstate = get_parent().states
		
		backup_default_speed = get_parent().static_player_speed
		get_parent().default_player_speed = 1.5*backup_default_speed
	elif(caller == "Boss"):
		facedir = get_parent().BossFace
		facestate = get_parent().charFaceState
		action = get_parent().Animate_state
		actionstate = get_parent().states
		
		backup_default_speed = get_parent().static_boss_speed
		get_parent().default_boss_speed = 1.5*backup_default_speed
	## Set speed

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## Update direction
	if(caller == "Player"):
		facedir = get_parent().charFace
		action = get_parent().plystate
	elif(caller == "Boss"):
		facedir = get_parent().BossFace
		action = get_parent().Animate_state
	
	if(action == actionstate.WALK): 
		$RushEffect.show()
		$AnimationPlayer.play("Active")
	else: $RushEffect.hide()
	
	if(skilltime > 0): 
		skilltime -= delta
	elif(skilltime <= 0):
		if(caller == "Player"):
			get_parent().default_player_speed = backup_default_speed
		elif(caller == "Boss"):
			get_parent().default_boss_speed = backup_default_speed
			
		queue_free()
		
	if(facedir == facestate.LEFT):
		$RushEffect.rotation_degrees = 180
		$RushEffect.flip_h = true
		$RushEffect.flip_v = true
	elif(facedir == facestate.RIGHT):
		$RushEffect.rotation_degrees = 0
		$RushEffect.flip_h = true
		$RushEffect.flip_v = false
		
