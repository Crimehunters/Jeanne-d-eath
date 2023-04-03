extends Node2D


var target
var init_position
var direction = Vector2.ZERO
var caller
#var backup_atk_cd = 0

func _ready():
	$AnimationPlayer.play("Active")
	if(caller == "Player"):
		init_position = get_parent().get_node("Player").position
		position = init_position
		if(get_parent().has_node("Boss")): target = get_parent().get_node("Boss").position
		else: queue_free()
		get_parent().get_node("Player").hide()
		get_parent().get_node("Player").set_process(false)
	elif(caller == "Boss"):
		init_position = get_parent().get_node("Boss").position
		position = init_position
		if(get_parent().has_node("Player")): target = get_parent().get_node("Player").position
		else: queue_free()
		get_parent().get_node("Boss").hide()
		get_parent().get_node("Boss").set_process(false)

func _process(delta):
	## Update direction
	if(caller == "Player"):
		if(get_parent().has_node("Player")): position = get_parent().get_node("Player").position
		else: queue_free()
		if(get_parent().has_node("Boss")): target = get_parent().get_node("Boss").position
		else: queue_free()
		
	elif(caller == "Boss"):
		if(get_parent().has_node("Boss")): position = get_parent().get_node("Boss").position
		else: queue_free()
		if(get_parent().has_node("Player")): target = get_parent().get_node("Player").position
		else: queue_free()
		position.y -= 70

	direction = (target - position).normalized()

func wait_warp_finished():
	if(caller == "Player"):
		get_parent().get_node("Player").position = target
		get_parent().get_node("Player").show()
		get_parent().get_node("Player").set_process(true)
	elif(caller == "Boss"):
		get_parent().get_node("Boss").position = target
		get_parent().get_node("Boss").show()
		get_parent().get_node("Boss").set_process(true)
		
	queue_free()
