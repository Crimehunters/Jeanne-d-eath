extends Node

export var health = 3
var currentHP
var SkillKeys = [0,0,0]
var current_stage
export var AtkDMG = 5
var current_atkdmg
var current_obtained_skill_key # 0 means no obtained
### NA count for using in skill limit ###
var skill_NA_hit = 0
var totaltime
var static_totaltime = 0 ## for save time recording
var isTimercount
enum modes {PRACTICE,NORMAL}
onready var selectedMode = modes.NORMAL

## Only for practice mode
var death_count = 0

var save_data: Dictionary

## for further save system
func save_collect():
	save_data = {
		"skill_obtained": SkillPool.availableSkill.keys()
	}

func save_game():
	save_collect()
	var save_file = File.new()
	save_file.open_encrypted_with_pass("user://savegame.save", File.WRITE, "Jeanne")
	save_file.store_line(to_json(save_data))
	save_file.close()

func reset():
	current_atkdmg = AtkDMG
	
func full_reset():
	_init()
	if(selectedMode == modes.PRACTICE): death_count = 0

func _init():
	currentHP = health
	SkillKeys = [0,0,0]
	current_stage = 1
	current_atkdmg = AtkDMG
	current_obtained_skill_key = 0
	totaltime = 0
	isTimercount = false
	
func _ready():
	pass

func startTimer():
	isTimercount = true

func stopTimer():
	isTimercount = false
		
func _process(delta):
	if(isTimercount): totaltime += delta
	#print(totaltime)
