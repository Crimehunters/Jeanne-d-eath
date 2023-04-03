extends Node2D

var facedir
var facedirstate
var caller
# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.4
	if(caller == "Player"):
		facedir = get_parent().charFace
	elif(caller == "Boss"):
		facedir = get_parent().BossFace
		self.scale.x = 2.5
		self.scale.y = 2.5
		self.position.y = -30
		
	facedirstate = get_parent().charFaceState
	# Define invincible count
	if(caller == "Player"):
		get_parent().invincibleCount = 1
	elif(caller == "Boss"):
		get_parent().invincibleCount = 2
		
	$AnimationPlayer.play("Active")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update direction
	if(caller == "Player"):
		facedir = get_parent().charFace
	elif(caller == "Boss"):
		facedir = get_parent().BossFace
	
	if(get_parent().invincibleCount == 0): queue_free()
	## Animation Modifier
	if(facedir == facedirstate.RIGHT):
		$Armorup.flip_h = false
	elif(facedir == facedirstate.LEFT):
		$Armorup.flip_h = true
