extends Control

var tips = [
	"Learn the boss pattern! This should helpful, maybe...",
	"Try using others skill, It may be effective with the fight",
	"Don't bash them heads on! Hit & Roll!!",
	"A combination of boss attack & skills can do devastating damage!",
	"Careful with your surrounding or you might be cornered"
]
# Called when the node enters the scene tree for the first time.
func _ready():
	if(get_parent().has_node("Victory")): queue_free()
	$CenterContainer/VBoxContainer/DefeatedLabel.percent_visible = 0
	$CenterContainer/VBoxContainer/Tips.percent_visible = 0
	
	randomize()
	tips.shuffle()
	$CenterContainer/VBoxContainer/Tips.bbcode_text = tips[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CenterContainer/VBoxContainer/DefeatedLabel.percent_visible += 0.02
	$CenterContainer/VBoxContainer/Tips.percent_visible += 0.01

func _on_Back_pressed():
	PlayerInfo.full_reset()
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")
