extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.4
	PlayerInfo.currentHP -= 1
	PlayerInfo.current_atkdmg += 5
	$AnimationPlayer.play("Active")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(PlayerInfo.skill_NA_hit == 0):
		PlayerInfo.current_atkdmg -= 5
		queue_free()
