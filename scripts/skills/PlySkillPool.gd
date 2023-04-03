extends "res://scripts/SkillSelectionUI/BaseClass.gd"

var pool: Dictionary
var availableSkill: Dictionary

var bossSkill = {
	1: [6,10],
	2: [8,9],
	3: [7,12],
	4: [11,13],
	5: [14,15]
}

enum states {NEW,LOAD}
var data_state
var is_loaded = false

## Default pool
var emptySkill = BasisSkill.new()
var bloodRitual = BasisSkill.new()
var hiddenPower = BasisSkill.new()
var trackingBall = BasisSkill.new()
var beamShoot = BasisSkill.new()
var onemorelifetocall = BasisSkill.new()

##### Available after boss defeated #####
var armorUp = BasisSkill.new()
var recovery = BasisSkill.new()
var warCry = BasisSkill.new()
var ratBomb = BasisSkill.new()
var judgementCut = BasisSkill.new()
var rush = BasisSkill.new()
var eRay = BasisSkill.new()
var teaTime = BasisSkill.new()
var suffocation = BasisSkill.new()
var noEscape = BasisSkill.new()
var divineCorrupt = BasisSkill.new()

func add_obtained_skill(key):
	availableSkill[key] = pool[key]

func check_saved_data():
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		data_state = states.NEW
	else:
		data_state = states.LOAD

func load_save():
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		data_state = states.NEW
		availableSkill = {
			0: emptySkill,
			1: bloodRitual,
			2: hiddenPower,
			3: trackingBall,
			4: beamShoot,
			5: onemorelifetocall,
		}
	else:
		data_state = states.LOAD
		save_file.open_encrypted_with_pass("user://savegame.save", File.READ, "Jeanne")
		var loads = parse_json(save_file.get_line())
		print(loads["skill_obtained"])
		for i in loads["skill_obtained"]:
			add_obtained_skill(int(i))
		save_file.close()

func use(skillkey, caller: String):
	match skillkey:
		1:
			if(PlayerInfo.currentHP > 1 and bloodRitual.current_use_count > 0):
				print("Blood Ritual is called")
				PlayerInfo.skill_NA_hit = bloodRitual.count
				var bloodritual_ins = load("res://scenes/skills/BloodRitual.tscn").instance()
				get_node("/root/World/MainSort/Characters/Player").add_child(bloodritual_ins)
				bloodRitual.current_use_count -= 1
			else: print("Blood Ritual is limited")
			
		2:
			if (hiddenPower.current_use_count > 0):
				print("Hidden Power is called")
				var hiddenpower_ins = load("res://scenes/skills/HiddenPower.tscn").instance()
				get_node("/root/World/MainSort/Characters/Player").add_child(hiddenpower_ins)
				hiddenPower.current_use_count -= 1
			else:
				print("Hidden Power is limited")
		3:
			if (trackingBall.current_use_count > 0):
				print("Tracking ball is called")
				var trackingBall_ins = load("res://scenes/skills/TrackingBall.tscn").instance()
				get_node("/root/World/MainSort/Characters").add_child(trackingBall_ins)
				trackingBall.current_use_count -= 1
			else:
				print("Tracking ball is limited")
		4:
			if (beamShoot.current_use_count > 0):
				print("Beam Shoot is called")
				var beamshoot_ins = load("res://scenes/skills/BeamShoot.tscn").instance()
				get_node("/root/World/MainSort/Characters/Player").add_child(beamshoot_ins)
				beamShoot.current_use_count -= 1
			else:
				print("Beam Shoot is limited")
		5: ## Passive
			pass
			
		##########################################################################################
		##################################### Obtainable by boss #################################
		###########################################################################################
		6:
			if caller == "Boss":
				var armorup_ins = load("res://scenes/skills/ArmorUp.tscn").instance()
				armorup_ins.caller = caller
				get_node("/root/World/MainSort/Characters/Boss").add_child(armorup_ins)
			else:
				if (armorUp.current_use_count > 0):
					print("Armor Up is called")
					var armorup_ins = load("res://scenes/skills/ArmorUp.tscn").instance()
					armorup_ins.caller = caller
					get_node("/root/World/MainSort/Characters/Player").add_child(armorup_ins)
					armorUp.current_use_count -= 1
				else:
					print("Armor Up is limited")
		7:
			if caller == "Boss":
				var recovery_ins = load("res://scenes/skills/Recovery.tscn").instance()
				recovery_ins.caller = caller
				get_node("/root/World/MainSort/Characters/Boss").add_child(recovery_ins)
			else:
				if (recovery.current_use_count > 0):
					print("Recovery is called")
					var recovery_ins = load("res://scenes/skills/Recovery.tscn").instance()
					recovery_ins.caller = caller
					get_node("/root/World/MainSort/Characters/Player").add_child(recovery_ins)
					recovery.current_use_count -= 1
				else:
					print("Recovery is limited")
		8:
			if caller == "Boss":
				var warcry_ins = load("res://scenes/skills/WarCry.tscn").instance()
				warcry_ins.caller = caller
				get_node("/root/World/MainSort/Characters/Boss").add_child(warcry_ins)
			else:
				if (warCry.current_use_count > 0):
					print("Warcry is called")
					var warcry_ins = load("res://scenes/skills/WarCry.tscn").instance()
					warcry_ins.caller = caller
					get_node("/root/World/MainSort/Characters/Player").add_child(warcry_ins)
					warCry.current_use_count -= 1
				else:
					print("Warcry is limited")
		9:
			if caller == "Boss":
				var ratBomb_ins = load("res://scenes/skills/RatBomb.tscn").instance()
				ratBomb_ins.caller = caller
				get_node("/root/World/MainSort/Characters").add_child(ratBomb_ins)
			else:
				if (ratBomb.current_use_count > 0):
					print("Rat Bomb is called")
					var ratBomb_ins = load("res://scenes/skills/RatBomb.tscn").instance()
					ratBomb_ins.caller = caller
					get_node("/root/World/MainSort/Characters").add_child(ratBomb_ins)
					ratBomb.current_use_count -= 1
				else:
					print("Rat Bomb is limited")
		10:
			if caller == "Boss":
				var judgementCut_ins = load("res://scenes/skills/JudgementCut.tscn").instance()
				judgementCut_ins.caller = caller
				get_node("/root/World/MainSort/Characters/Boss").add_child(judgementCut_ins)
			else:
				if (judgementCut.current_use_count > 0):
					print("Judgement Cut is called")
					var judgementCut_ins = load("res://scenes/skills/JudgementCut.tscn").instance()
					judgementCut_ins.caller = caller
					get_node("/root/World/MainSort/Characters/Player").add_child(judgementCut_ins)
					judgementCut.current_use_count -= 1
				else:
					print("Judgement Cut is limited")
		11:
			if caller == "Boss":
				var rush_ins = load("res://scenes/skills/Rush.tscn").instance()
				rush_ins.caller = caller
				get_node("/root/World/MainSort/Characters/Boss").add_child(rush_ins)
			else:
				if (rush.current_use_count > 0):
					print("Rush is called")
					var rush_ins = load("res://scenes/skills/Rush.tscn").instance()
					rush_ins.caller = caller
					get_node("/root/World/MainSort/Characters/Player").add_child(rush_ins)
					rush.current_use_count -= 1
				else:
					print("Rush is limited")
		12:
			if caller == "Boss":
				var eRay_ins = load("res://scenes/skills/ExtinctionRay.tscn").instance()
				eRay_ins.caller = caller
				get_node("/root/World/MainSort/Characters/Boss").add_child(eRay_ins)
			else:
				if (eRay.current_use_count > 0):
					print("Extinction Ray is called")
					var eRay_ins = load("res://scenes/skills/ExtinctionRay.tscn").instance()
					eRay_ins.caller = caller
					get_node("/root/World/MainSort/Characters/Player").add_child(eRay_ins)
					eRay.current_use_count -= 1
				else:
					print("Extinction Ray is limited")
		13:
			if caller == "Boss":
				var teaTime_ins = load("res://scenes/skills/TeaTime.tscn").instance()
				teaTime_ins.caller = caller
				
				## Apply debuff directly to target instead
				get_node("/root/World/MainSort/Characters/Player").add_child(teaTime_ins)
			else:
				if (teaTime.current_use_count > 0):
					print("Tea Time is called")
					var teaTime_ins = load("res://scenes/skills/TeaTime.tscn").instance()
					teaTime_ins.caller = "Player"
					## Apply debuff directly to target instead
					get_node("/root/World/MainSort/Characters/Boss").add_child(teaTime_ins)
					teaTime.current_use_count -= 1
				else:
					print("Tea Time is limited")
		14:
			if caller == "Boss":
				var suffocation_ins = load("res://scenes/skills/Suffocation.tscn").instance()
				suffocation_ins.caller = caller
				get_node("/root/World/MainSort/Characters").add_child(suffocation_ins)
			else:
				if (suffocation.current_use_count > 0):
					print("Suffocation is called")
					var suffocation_ins = load("res://scenes/skills/Suffocation.tscn").instance()
					suffocation_ins.caller = caller
					get_node("/root/World/MainSort/Characters").add_child(suffocation_ins)
					suffocation.current_use_count -= 1
				else:
					print("Suffocation  is limited")
		15:
			if caller == "Boss":
				var noEscape_ins = load("res://scenes/skills/NoEscape.tscn").instance()
				noEscape_ins.caller = caller
				get_node("/root/World/MainSort/Characters").add_child(noEscape_ins)
			else:
				if (noEscape.current_use_count > 0):
					print("No Escape is called")
					var noEscape_ins = load("res://scenes/skills/NoEscape.tscn").instance()
					noEscape_ins.caller = caller
					get_node("/root/World/MainSort/Characters").add_child(noEscape_ins)
					noEscape.current_use_count -= 1
				else:
					print("No Escape is limited")
					
		16: ### Exclusive for The False Apostle
			print("No Escape is called")
			var divineCorrupt_ins = load("res://scenes/skills/DivineCorrupt.tscn").instance()
			get_node("/root/World/MainSort/Characters").add_child(divineCorrupt_ins)
	
func skill_setup():
	## Empty ##
	emptySkill.icon_texture = Texture
	## S1 ##
	bloodRitual.title = "Blood Ritual"
	bloodRitual.description = "Sacrifice 1 HP for increase 5 damage in normal attack 3 times but when HP is 1, this skill will be unavailable"
	bloodRitual.icon_texture = preload("res://sprites/skills/s1.png")
	bloodRitual.dmg = 1
	bloodRitual.count = 3
	bloodRitual.type = "Buff"
	bloodRitual.current_use_count = bloodRitual.count
	## S2 ##
	hiddenPower.title = "Hidden Power"
	hiddenPower.description = "Charge 3 sec. and release damaging punch in front of player, dealing 10 DAMAGE"
	hiddenPower.icon_texture = preload("res://sprites/skills/s2.png")
	hiddenPower.dmg = 10
	hiddenPower.count = 2
	hiddenPower.type = "Active"
	hiddenPower.current_use_count = hiddenPower.count
	## S3 ##
	trackingBall.title = "Tracking Ball"
	trackingBall.description = "Generating a homing energy ball, dealing 1 DAMAGE"
	trackingBall.icon_texture = preload("res://sprites/skills/s3.png")
	trackingBall.dmg = 1
	trackingBall.count = 15
	trackingBall.type = "Active"
	trackingBall.current_use_count = trackingBall.count
	## S4 ##
	beamShoot.title = "Beam Shoot"
	beamShoot.description = "Shooting a straight line beam that last for 3 seconds, dealing 5 DAMAGE per sec."
	beamShoot.icon_texture = preload("res://sprites/skills/s4.png")
	beamShoot.dmg = 5
	beamShoot.count = 4
	beamShoot.type = "Active"
	beamShoot.current_use_count = beamShoot.count
	## S5 ##
	onemorelifetocall.title = "One More Life To Call"
	onemorelifetocall.description = "[Passive] When defeated boss, gaining 0.5 HP at the start of the next stage"
	onemorelifetocall.icon_texture = preload("res://sprites/skills/s5.png")
	onemorelifetocall.dmg = 0
	onemorelifetocall.count = 0
	onemorelifetocall.type = "Passive"
	onemorelifetocall.current_use_count = onemorelifetocall.count
	## S6 ##
	armorUp.title = "Armor Up"
	armorUp.description = "Negate enemy's normal attack 1 times"
	armorUp.icon_texture = preload("res://sprites/skills/s6.png")
	armorUp.dmg = 0
	armorUp.count = 2
	armorUp.type = "Buff"
	armorUp.current_use_count = armorUp.count
	## S7 ##
	recovery.title = "Recovery"
	recovery.description = "Instant heal for 1.5 HP"
	recovery.icon_texture = preload("res://sprites/skills/s7.png")
	recovery.dmg = 0
	recovery.count = 1
	recovery.type = "Heal"
	recovery.current_use_count = recovery.count
	## S8 ##
	warCry.title = "War Cry"
	warCry.description = "Enhance normal attack damage by 2 for 10 seconds"
	warCry.icon_texture = preload("res://sprites/skills/s8.png")
	warCry.dmg = 0
	warCry.count = 2
	warCry.type = "Buff"
	warCry.current_use_count = warCry.count
	## S9 ##
	ratBomb.title = "Rat Bomb"
	ratBomb.description = "Summon a mouse targeting the enemy for 8 seconds, dealing 1.5 DAMAGE per sec. After that, it'll explode and deal 5 DAMAGE"
	ratBomb.icon_texture = preload("res://sprites/skills/s9.png")
	ratBomb.dmg = 1.5
	ratBomb.count = 5
	ratBomb.type = "Active"
	ratBomb.current_use_count = ratBomb.count
	## S10 ##
	judgementCut.title = "Judgment Cut"
	judgementCut.description = "Charge for 3 sec. to create large area of slashes, dealing 3 DAMAGE 9 times"
	judgementCut.icon_texture = preload("res://sprites/skills/s10.png")
	judgementCut.dmg = 3
	judgementCut.count = 2
	judgementCut.type = "Active"
	judgementCut.current_use_count = judgementCut.count
	## S11 ##
	rush.title = "Rush"
	rush.description = "Increase movement speed 50% for 8 seconds"
	rush.icon_texture = preload("res://sprites/skills/s11.png")
	rush.dmg = 0
	rush.count = 2
	rush.type = "Buff"
	rush.current_use_count = rush.count
	## S12 ##
	eRay.title = "Extinction Ray"
	eRay.description = "Charge for 2.5 sec. then shooting an instantaneous ray to the front for a long distance, dealing 4 DAMAGE"
	eRay.icon_texture = preload("res://sprites/skills/s12.png")
	eRay.dmg = 4
	eRay.count = 4
	eRay.type = "Active"
	eRay.current_use_count = eRay.count
	## S13 ##
	teaTime.title = "Tea Time"
	teaTime.description = "Stop enemy movement for 5 seconds and increase normal attack damage by 3 during that time"
	teaTime.icon_texture = preload("res://sprites/skills/s13.png")
	teaTime.dmg = 0
	teaTime.count = 2
	teaTime.type = "Active"
	teaTime.current_use_count = teaTime.count
	## S14 ##
	suffocation.title = "Suffocation"
	suffocation.description = "Create holy area for 20 seconds with 40% slow on target and dealing 1.5 DAMAGE per sec."
	suffocation.icon_texture = preload("res://sprites/skills/s14.png")
	suffocation.dmg = 1.5
	suffocation.count = 2
	suffocation.type = "Active"
	suffocation.current_use_count = suffocation.count
	## S15 ##
	noEscape.title = "No Escape"
	noEscape.description = "Warp to target"
	noEscape.icon_texture = preload("res://sprites/skills/s15.png")
	noEscape.dmg = 0
	noEscape.count = 5
	noEscape.type = "Active"
	noEscape.current_use_count = noEscape.count
	## S16 ##
	divineCorrupt.title = "Divine Corrupt"
	divineCorrupt.description = "Charging holy judgment for 8 seconds then unleash power that instant kill player"
	divineCorrupt.icon_texture = preload("res://sprites/skills/s16.png")
	
func _init():
	pass

func reset():
	for i in pool:
		if i != 0:
			pool[i].current_use_count = pool[i].count
			
func full_reset():
	skill_setup()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	skill_setup()	
	##### Adding all to pool #####
	pool = {
		0: emptySkill,
		1: bloodRitual,
		2: hiddenPower,
		3: trackingBall,
		4: beamShoot,
		5: onemorelifetocall,
		6: armorUp,
		7: recovery,
		8: warCry,
		9: ratBomb,
		10: judgementCut,
		11: rush,
		12: eRay,
		13: teaTime,
		14: suffocation,
		15: noEscape
	}
	
	## Load save or new	
	load_save()

	print("SkillpoolSide:", availableSkill)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
