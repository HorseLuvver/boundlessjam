extends Node2D

export (float) var dashtime = 0.3
onready var dashtimer = Timer.new()
onready var lettertimer = Timer.new()
var letter = ""
var letters = {
	"⋅-":"A",
	"-⋅⋅⋅":"B",
	"-⋅-⋅":"C",
	"-⋅⋅":"D",
	"⋅":"E",
	"⋅⋅-⋅":"F",
	"--⋅":"G",
	"⋅⋅⋅⋅":"H",
	"⋅⋅":"I",
	"⋅---":"J",
	"-⋅-":"K",
	"⋅-⋅⋅":"L",
	"--":"M",
	"-⋅":"N",
	"---":"O",
	"⋅--⋅":"P",
	"--⋅-":"Q",
	"⋅-⋅":"R",
	"⋅⋅⋅":"S",
	"-":"T",
	"⋅⋅-":"U",
	"⋅⋅⋅-":"V",
	"⋅--":"W",
	"-⋅⋅-":"x",
	"-⋅--":"Y",
	"--⋅⋅":"Z",
}
var enemy_scenes = {
	"Bat":preload("res://Animals/Stage 1/Bat.tscn"),
	"Cat":[],
	"Dog":[],
	"Rat":[],
	"Fish":[],
	"Frog":[],
	"Newt":[],
	"Swan":[],
	"Camel":[],
	"Gecko":[],
	"Eagle":[],
	"Snake":[]
}

func _ready():
	Game.player = $Player
	Game.particles = $Player/CPUParticles2D
	Game.dash_progress_bar = $Player/ProgressBar
	var enemies = Game.enemy_battle_data
	for i in range(len(enemies)):
		var enemy = enemy_scenes[enemies[i]] .instance()
		get_node("EnemyPosition%s" % i).add_child(enemy)
	add_child(dashtimer)
	add_child(lettertimer)
	dashtimer.one_shot = true
	dashtimer.wait_time = dashtime
	lettertimer.one_shot = true
	dashtimer.connect("timeout", self, "on_DashTimer_timeout")
	lettertimer.connect("timeout", self, "on_LetterTimer_timeout")
	
func _physics_process(delta): 
	interpret_morse()
	if dashtimer.time_left: $Player/ProgressBar.value = dashtimer.time_left / dashtime
	else: $Player/ProgressBar.value = 0

func on_DashTimer_timeout():
	letter += "-"

func on_LetterTimer_timeout():
	if letter in letters.keys():
		print(letters[letter])
		$Player/CPUParticles2D.texture = load("res://Battle/Letters/letters_%s.png" % letters[letter])
		$Player/CPUParticles2D.emitting = true
	else: print(letter)
	letter = ""

func interpret_morse():
	if Input.is_action_just_released("button") and not dashtimer.is_stopped():
		dashtimer.stop()
		lettertimer.start()
		letter += "⋅"
	elif Input.is_action_just_released("button"):
		lettertimer.start()
	elif Input.is_action_just_pressed("button"):
		dashtimer.start()
		if not lettertimer.is_stopped(): lettertimer.stop()
