extends Control

var waitTime = 3
var inputBlocker = 2


var titleName = [
	"The Bridge",
	"The Laboratory",
	"The Room",
	"The Forest",
	"The Catacomb"
]
# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/Title.bbcode_text = "[center]" + "Stage " + str(PlayerInfo.current_stage) + ": " + titleName[PlayerInfo.current_stage-1]
	$CenterContainer/VBoxContainer/Lore.get_v_scroll().value = 0
		
func _process(delta):
	if(inputBlocker > 0): inputBlocker -= delta
	else: inputBlocker = 0
	
	if (waitTime > 0): waitTime -= delta
	else:
		$CenterContainer/VBoxContainer/Lore.get_v_scroll().value += 0.5

func _on_Continue_pressed():
	if(inputBlocker <= 0):
		get_tree().change_scene("res://Boss_" + str(PlayerInfo.current_stage) + "_world.tscn")
		PlayerInfo.startTimer()
