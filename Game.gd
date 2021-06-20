extends Node2D

var word = []
var letter = ""
var MODE = "wander"

func _ready():
	$DashTimer.connect("timeout", self, "on_DashTimer_timeout")
	$LetterTimer.connect("timeout", self, "on_LetterTimer_timeout")
	$WordTimer.connect("timeout", self, "on_WordTimer_timeout")

func _physics_process(delta):
	if MODE == "battle": interpret_morse()

func on_DashTimer_timeout():
	letter += "-"

func on_LetterTimer_timeout():
	word.append(letter)
	letter = ""

func on_WordTimer_timeout():
	print(word)
	word.clear()

func interpret_morse():
	if Input.is_action_just_released("button") and not $DashTimer.is_stopped():
		$DashTimer.stop()
		$LetterTimer.start(1)
		$WordTimer.start()
		letter += "⋅"
	elif Input.is_action_just_pressed("button"):
		$DashTimer.start(0.5)
		if $LetterTimer.is_stopped(): $LetterTimer.stop()
		if $WordTimer.is_stopped(): $WordTimer.stop()
