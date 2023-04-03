extends Node2D


var chargeTime = 8
enum state {CHARGE, RELEASE}
onready var skillstate = state.CHARGE
var target
var init_position
var facedir
var facedirstate
var TargetArray = []
# Called when the node enters the scene tree for the first time.
func _ready():
	facedir = get_parent().get_node("Boss").BossFace
	facedirstate = get_parent().get_node("Boss").charFaceState
	if(get_parent().has_node("Boss")): init_position = get_parent().get_node("Boss").position
	else: queue_free()
	position = init_position
	
	$AnimationPlayer.play("Charge")

func _process(delta):
	## Update direction
	facedir = get_parent().get_node("Boss").BossFace
	print("BossFace", get_parent().get_node("Boss").BossFace)
	if(get_parent().has_node("Boss")): position = get_parent().get_node("Boss").position
	else: queue_free()
	
	
	if(chargeTime > 0): chargeTime -= delta
	elif(chargeTime <= 0):
		skillstate = state.RELEASE
	
	if(skillstate == state.RELEASE):
		$DivinecorruptCharge.hide()
		$DivinecorruptEffect.show()
		#get_parent().get_node("Boss").hide()
		#get_parent().get_node("Boss").set_process(false)
		$AnimationPlayer.play("Release")
		
	## Animation Modifier
	if(facedir == facedirstate.RIGHT):
		$DivinecorruptCharge.flip_h = false
		$DivinecorruptEffect.rotation_degrees = 0
		$HitboxAttack.rotation_degrees = 0
	elif(facedir == facedirstate.LEFT):
		$DivinecorruptCharge.flip_h = true
		$DivinecorruptEffect.flip_h = true
		$HitboxAttack.rotation_degrees = 180
		$DivinecorruptEffect.rotation_degrees = 180
		
func apply_hitbox():
	for i in TargetArray:
		if(i.name == "Player"):
			i.take_dmg_from_boss_skills(PlayerInfo.currentHP, Vector2.ZERO, 0)
	
func wait_release_finished():
	#get_parent().get_node("Boss").show()
	#get_parent().get_node("Boss").set_process(true)
	queue_free()


func _on_HitboxAttack_body_entered(body):
	TargetArray.append(body)

func _on_HitboxAttack_body_exited(body):
	TargetArray.remove(TargetArray.find(body))
