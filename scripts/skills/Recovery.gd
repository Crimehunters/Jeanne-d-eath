extends Node2D


var caller
# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.5
	$AnimationPlayer.play("Active")
	if(caller == "Boss"):
		self.scale.x = 2
		self.scale.y = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func heal_activate():
	if(caller == "Player"):
		PlayerInfo.currentHP += 1.5
	elif(caller == "Boss"): ## 25% of max HP
		get_parent().hp += 0.25*get_parent().default_boss_hp

func wait_heal_animation_finished():
	queue_free()
