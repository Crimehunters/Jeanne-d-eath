extends Control

var xsize: int = 315
# Called when the node enters the scene tree for the first time.

func _ready():
	$Life/TextureRect.rect_size.x = PlayerInfo.health * xsize
	if(PlayerInfo.selectedMode == PlayerInfo.modes.PRACTICE):
		$Skull.visible = true
		$DeathText.visible = true
		$DeathText/Count.bbcode_text = "[center][b]" + str(PlayerInfo.death_count)
	else:
		$Skull.visible = false
		$DeathText.visible = false
	
func _on_Player_hit(dmg):
	PlayerInfo.currentHP -= dmg
	if(PlayerInfo.currentHP <= 0 and PlayerInfo.selectedMode == PlayerInfo.modes.PRACTICE):
		$FX.stream = load("res://sound/fx/death.mp3")
		$FX.play()
		PlayerInfo.death_count += 1
		$DeathText/Count.bbcode_text = "[center][b]" + str(PlayerInfo.death_count)
		
	#print("CurrentHP: ", PlayerInfo.currentHP)
	$Life/TextureRect.rect_size.x = PlayerInfo.currentHP * xsize
	
func _process(delta):
	### Update HP texture all the time (Support sacrifice HP for benefit)
	$Life/TextureRect.rect_size.x = PlayerInfo.currentHP * xsize
	pass
	
