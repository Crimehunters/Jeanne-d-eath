extends Node2D


var backup_default_speed
var skilltime = 5
var bossSkillTime = 1.5
var caller
# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.6
	
	if(caller == "Player"):
		backup_default_speed = get_node("/root/World/MainSort/Characters/Boss").default_boss_speed
		get_node("/root/World/MainSort/Characters/Boss").default_boss_speed = 0
		
		## Increase NA
		PlayerInfo.current_atkdmg += 3
	elif(caller == "Boss"):
		backup_default_speed = get_node("/root/World/MainSort/Characters/Player").default_player_speed
		get_node("/root/World/MainSort/Characters/Player").default_player_speed = 0
	$AnimationPlayer.play("Active")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(caller == "Player"):
		if (skilltime > 0): skilltime -= delta
		elif (skilltime <= 0):
			get_node("/root/World/MainSort/Characters/Boss").default_boss_speed = backup_default_speed
			PlayerInfo.current_atkdmg -= 3
			queue_free()
	elif(caller == "Boss"):
		if (bossSkillTime > 0): bossSkillTime -= delta
		elif (bossSkillTime <= 0):
			get_node("/root/World/MainSort/Characters/Player").default_player_speed = backup_default_speed
			queue_free()
		
		
