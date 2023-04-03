extends Node2D

var dmgTick = 1 ## Continuous DMG time tick
var current_dmgTick 
var releaseTime = 3
var plydirection
var TargetArray = []
var plyfacedir
var plyfacestate
# Called when the node enters the scene tree for the first time.
func _ready():
	plydirection = get_parent().input
	plyfacedir = get_parent().charFace
	plyfacestate = get_parent().charFaceState
	current_dmgTick = dmgTick

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## Update Direction
	plydirection = get_parent().input
	plyfacedir = get_parent().charFace
	
	## Animation Modifier
	if(plyfacedir == plyfacestate.RIGHT or plydirection.x > 0):
		$Hitbox.rotation_degrees = 0
		$Beamshoot.rotation_degrees = 0
	elif(plyfacedir == plyfacestate.RIGHT or plydirection.x < 0):
		$Hitbox.rotation_degrees = 180
		$Beamshoot.rotation_degrees = 180
	
	## Beamshoot animation
	if(releaseTime > 0):
		$AnimationPlayer.play("Shoot")
		releaseTime -= delta
	elif(releaseTime <= 0):
		$AnimationPlayer.stop()
		queue_free()
		
	## Beamshoot DMG count
	if(current_dmgTick > 0):
		current_dmgTick -= delta
	elif(current_dmgTick <= 0):
		apply_hitbox()
		current_dmgTick = 1
	
	
func apply_hitbox():	
	for i in TargetArray:
		if(i.name == "Boss"):
			if(plyfacedir == plyfacestate.LEFT):
				i.take_dmg_from_skill(SkillPool.beamShoot.dmg, Vector2.LEFT, 6000)
			elif(plyfacedir == plyfacestate.RIGHT):
				i.take_dmg_from_skill(SkillPool.beamShoot.dmg, Vector2.RIGHT, 6000)

func _on_Hitbox_body_entered(body):
	if body.name != "Player":
		TargetArray.append(body)


func _on_Hitbox_body_exited(body):
	TargetArray.remove(TargetArray.find(body))
