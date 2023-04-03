extends Node

class BasisSkill:
	var title : String
	var description : String
	var icon_texture : Texture
	#var cooldown: float
	var count: int
	var dmg : int
	var type: String # Active, Passive
	
	#var current_cd: float
	var current_use_count: int
