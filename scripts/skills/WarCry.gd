extends Node2D


var skillTimer = 10
var bossSkillTimer = 5
var caller
# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.6
	if(caller == "Player"):
		PlayerInfo.current_atkdmg += 2
	elif(caller == "Boss"):
		get_parent().dmg += 0.5
		self.scale.x = 3
		self.scale.y = 3
	$AnimationPlayer.play("Active")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(caller == "Player"):
		if(skillTimer > 0): skillTimer -= delta
		elif(skillTimer <= 0):
			PlayerInfo.current_atkdmg -= 2
			queue_free()
	elif(caller == "Boss"):
		if(bossSkillTimer > 0): bossSkillTimer -= delta
		elif(bossSkillTimer <= 0):
			get_parent().dmg -= 0.5
			queue_free()
