extends Node2D

signal letter
export (float) var dashtime = 0.3
onready var dashtimer = Timer.new()
onready var lettertimer = Timer.new()
export (bool) var order_required = false
var letter_scene = preload("Letters/Letter.tscn")
var letter = ""
var morse_to_letters = {
	"._":"A",
	"_...":"B",
	"_._.":"C",
	"_..":"D",
	".":"E",
	".._.":"F",
	"__.":"G",
	"....":"H",
	"..":"I",
	".___":"J",
	"_._":"K",
	"._..":"L",
	"__":"M",
	"_.":"N",
	"___":"O",
	".__.":"P",
	"__._":"Q",
	"._.":"R",
	"...":"S",
	"_":"T",
	".._":"U",
	"..._":"V",
	".__":"W",
	"_.._":"x",
	"_.__":"Y",
	"__..":"Z",
}
var letters_to_morse = {}
var enemy_scenes = {
	"BAT":preload("res://Animals/Stage 1/Bat.tscn"),
	"CAT":[],
	"DOG":[],
	"RAT":[],
	"FISH":[],
	"FROG":[],
	"NEWT":[],
	"SWAN":[],
	"CAMEL":[],
	"GECKO":[],
	"EAGLE":[],
	"SNAKE":[],
	"WALRUS":[]
}

var enemy_move_damage = {
	"bite": 7,
	"claw": 10,
	"pounce": 12,
	
}
func _ready():
	for key in morse_to_letters.keys():
		letters_to_morse[morse_to_letters[key]] = key
	Game.player = $Player
	Game.particles = $Player/CPUParticles2D
	Game.dash_progress_bar = $Player/DashBar
	var enemies = Game.enemy_battle_data
	for i in range(len(enemies)):
		var enemy = enemy_scenes[enemies[i]] .instance()
		get_node("EnemyPosition%s" % i).add_child(enemy)
		var attack_timer = Timer.new()
		attack_timer.name = "AttackTimer"
		enemy.add_child(attack_timer)
		attack_timer.wait_time = rand_range(2, 4)
		attack_timer.connect("timeout", enemy, "on_AttackTimer_timeout")
		attack_timer.start()
		connect("letter", enemy, "letter_recieved")
		enemy.connect("attack", self, "attacked")
		enemy.input_pickable = true
		for l in enemy.name.to_upper():
			var letter_node = letter_scene.instance()
			letter_node.texture = load("res://Battle/Letters/%s/letters_%s.png" % [l, l])
			letter_node.name = l
			enemy.get_node("../Name/MarginContainer/HBoxContainer").add_child(letter_node)
			letter_node.connect("mouse_entered", self, "on_mouse_entered_letter", [letter_node])
			letter_node.connect("mouse_exited", self, "on_mouse_exited_letter", [letter_node])
			letter_node.get_node("PopupPanel/MarginContainer/Label").text = letters_to_morse[l]
			#print(letter_node.get_node("PopupPanel/MarginContainer/Label").text)
			letter_node.get_node("PopupPanel").rect_size = Vector2(len(letters_to_morse[l]) * 5 + 4.5, 9)
			letter_node.get_node("PopupPanel").rect_position = Vector2(-len(letters_to_morse[l]) * 2.5 - 0.5, -12)
		enemy.get_node("../Name").rect_size = Vector2(len(enemy.name) * 7 + 2, 12)
		enemy.get_node("../Name").rect_position = Vector2(-len(enemy.name) * 3 - 0.5, -20)
		enemy.get_node("../Name").visible = true
	add_child(dashtimer)
	add_child(lettertimer)
	dashtimer.one_shot = true
	dashtimer.wait_time = dashtime
	lettertimer.one_shot = true
	dashtimer.connect("timeout", self, "on_DashTimer_timeout")
	lettertimer.connect("timeout", self, "on_LetterTimer_timeout")
	
func _physics_process(delta): 
	interpret_morse()
	if dashtimer.time_left: $Player/DashBar.value = dashtimer.time_left / dashtime
	else: $Player/DashBar.value = 0

func on_DashTimer_timeout():
	letter += "_"

func on_LetterTimer_timeout():
	if letter in morse_to_letters.keys():
		print(morse_to_letters[letter])
		$Player/CPUParticles2D.texture = load("res://Battle/Letters/%s/letters_%s.png" % [morse_to_letters[letter], morse_to_letters[letter]])
		$Player/CPUParticles2D.emitting = true
		$Player/AnimatedSprite.play("attack")
		$Player.switch_animation = "idle"
		emit_signal("letter", morse_to_letters[letter])
	else: print(letter)
	letter = ""

func interpret_morse():
	if Input.is_action_just_released("button") and not dashtimer.is_stopped():
		dashtimer.stop()
		lettertimer.start()
		letter += "."
	elif Input.is_action_just_released("button"):
		lettertimer.start()
	elif Input.is_action_just_pressed("button"):
		dashtimer.start()
		if not lettertimer.is_stopped(): lettertimer.stop()

func on_mouse_entered_letter(letter_node):
	letter_node.get_node("PopupPanel").visible = true
	
func on_mouse_exited_letter(letter_node):
	letter_node.get_node("PopupPanel").visible = false

func attacked(move): #player has been attacked by a monster
	$Player.data.hp -= enemy_move_damage[move]
	if $Player.data.hp > 0: $Player/HealthBar.value = $Player.data.hp / $Player.max_hp
	else: get_tree().change_scene("GameOver.tscn") 
