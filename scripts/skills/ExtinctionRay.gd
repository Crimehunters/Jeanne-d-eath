extends Node2D

var chargeTime = 1.5
enum states {CHARGE, RELEASE}
onready var skillstate = states.CHARGE
var TargetArray = []
var facedir
var facestate
var caller

# Called when the node enters the scene tree for the first time.
func _ready():
	$ExtinctionrayCharge.modulate.a = 0.5
	facestate = get_parent().charFaceState
	if(caller == "Player"):
		facedir = get_parent().charFace
	elif(caller == "Boss"):
		self.scale.x = 2.5
		self.scale.y = 2.5
		facedir = get_parent().BossFace
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## Update Direction
	if(caller == "Player"):
		facedir = get_parent().charFace
	elif(caller == "Boss"):
		facedir = get_parent().BossFace
	
	if(chargeTime > 0): chargeTime -= delta
	elif(chargeTime <= 0):
		skillstate = states.RELEASE
		
	## Animation Modifier
	if(facedir == facestate.RIGHT):
		$HitboxAttack.rotation_degrees = 0
		$ExtinctionrayEffect.rotation_degrees = 0
		$ExtinctionrayCharge.flip_h = false
	elif(facedir == facestate.LEFT):
		$HitboxAttack.rotation_degrees = 180
		$ExtinctionrayEffect.rotation_degrees = 180
		$ExtinctionrayCharge.flip_h = true
		
	match skillstate:
		states.CHARGE:
			$AnimationPlayer.play("Charge")
		states.RELEASE:
			$ExtinctionrayCharge.hide()
			$ExtinctionrayEffect.show()
			$AnimationPlayer.play("Release")
	
func wait_release_finished():
	queue_free()
	
func apply_hitbox():
	if(caller == "Player"):
		for i in TargetArray:
			if(i.name == "Boss"):
				if(facedir == facestate.LEFT):
					i.take_dmg_from_skill(SkillPool.eRay.dmg, Vector2.LEFT, 4000)
				elif(facedir == facestate.RIGHT):
					i.take_dmg_from_skill(SkillPool.eRay.dmg, Vector2.RIGHT, 4000)
	elif(caller == "Boss"):
		for i in TargetArray:
			if(i.name == "Player"):
				if(facedir == facestate.LEFT):
					i.take_dmg_from_boss_skills(1, Vector2.LEFT, 4000)
				elif(facedir == facestate.RIGHT):
					i.take_dmg_from_boss_skills(1, Vector2.RIGHT, 4000)

func _on_HitboxAttack_body_entered(body):
	TargetArray.append(body)

func _on_HitboxAttack_body_exited(body):
	TargetArray.remove(TargetArray.find(body))
