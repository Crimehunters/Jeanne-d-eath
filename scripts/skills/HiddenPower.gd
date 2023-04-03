extends Node2D

enum states {CHARGE, RELEASE}
var skillstate
var plydirection
var current_chargetime
var TargetArray = []
var plyfacedir
var plyfacestate

func _ready():
	plydirection = get_parent().input
	plyfacedir = get_parent().charFace
	plyfacestate = get_parent().charFaceState
	current_chargetime = 3
	skillstate = states.CHARGE

func _process(delta):
	## Update Direction
	plydirection = get_parent().input
	plyfacedir = get_parent().charFace
	
	## Animation Modifier
	if(plyfacedir == plyfacestate.RIGHT or plydirection.x > 0):
		$Hitbox.rotation_degrees = 0
		$Hiddenpower.flip_h = false
	elif(plyfacedir == plyfacestate.LEFT or plydirection.x < 0):
		$Hitbox.rotation_degrees = 180
		$Hiddenpower.flip_h = true
		
	### Animation playing 
	match skillstate:
		states.CHARGE:
			$AnimationPlayer.play("Charge")
			if(current_chargetime > 0):
				current_chargetime -= delta
				print("Charge: ", current_chargetime)
			else: skillstate = states.RELEASE
		states.RELEASE:
			$AnimationPlayer.play("Release")

func wait_release_finished():
	queue_free()
	
	
func apply_hitbox():	
	for i in TargetArray:
		if(i.name == "Boss"):
			if(plyfacedir == plyfacestate.LEFT):
				i.take_dmg_from_skill(SkillPool.hiddenPower.dmg, Vector2.LEFT, 5000)
			elif(plyfacedir == plyfacestate.RIGHT):
				i.take_dmg_from_skill(SkillPool.hiddenPower.dmg, Vector2.RIGHT, 5000)

func _on_Hitbox_body_entered(body):
	TargetArray.append(body)


func _on_Hitbox_body_exited(body):
	TargetArray.remove(TargetArray.find(body))
