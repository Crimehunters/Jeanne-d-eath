extends Node2D


var chargetime = 3
enum states {
	CHARGE, RELEASE
}
var target
var TargetAttackAry = []
onready var skillstate = states.CHARGE
var facedir
var facestate
var pushbackVector
var caller
# Called when the node enters the scene tree for the first time.
func _ready():
	if(caller == "Player"):
		if(get_parent().get_parent().has_node("Boss")):
			target = get_node("/root/World/MainSort/Characters/Boss").position
		else: queue_free()
		facedir = get_parent().charFace
	elif(caller == "Boss"):
		if(get_parent().get_parent().has_node("Player")):
			target = get_node("/root/World/MainSort/Characters/Player").position
		else: queue_free()
		facedir = get_parent().BossFace
		self.scale.x = 2.5
		self.scale.y = 2.5
	
	facestate = get_parent().charFaceState
	pushbackVector = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## Update direction
	if(caller == "Player"):
		if(get_parent().get_parent().has_node("Boss")):
			target = get_node("/root/World/MainSort/Characters/Boss").position
		else: queue_free()
		facedir = get_parent().charFace
	elif(caller == "Boss"):
		if(get_parent().get_parent().has_node("Player")):
			target = get_node("/root/World/MainSort/Characters/Player").position
		else: queue_free()
		facedir = get_parent().BossFace
		
	pushbackVector = (target - position).normalized()
	
	### Animation playing 
	match skillstate:
		states.CHARGE:
			$AnimationPlayer.play("Charge")
			if(chargetime > 0):
				chargetime -= delta
				print("Charge: ", chargetime)
			else: skillstate = states.RELEASE
		states.RELEASE:
			if(caller == "Player"):
				get_parent().get_node("NewJeanne").hide()
				get_parent().set_process(false)
			elif(caller == "Boss"):
				get_parent().get_node("BossMain").hide()
				get_parent().set_process(false)
			
			$Judgementcut.show()
			$JudgementcutCharge.hide()
			$AnimationPlayer.play("Release")

func wait_release_finished():
	if(caller == "Player"):
		get_parent().get_node("NewJeanne").show()
		get_parent().set_process(true)
	elif(caller == "Boss"):
		get_parent().get_node("BossMain").show()
		get_parent().set_process(true)

	queue_free()
	
func apply_dmg():
	if(caller == "Player"):
		for i in TargetAttackAry:
			if(i.name == "Boss"):
				i.take_dmg_from_skill(SkillPool.judgementCut.dmg, pushbackVector, 1000)
	elif(caller == "Boss"):
		for i in TargetAttackAry:
			if(i.name == "Player"):
				i.take_dmg_from_boss_skills(0.1, pushbackVector, 1000)


func _on_HitboxAttack_body_entered(body):
	TargetAttackAry.append(body)

func _on_HitboxAttack_body_exited(body):
	TargetAttackAry.remove(TargetAttackAry.find(body))
