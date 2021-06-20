extends Node2D

var word = []
var letter = ""
var MODE = "battle"
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

func _ready():
	randomize()
	$DashTimer.connect("timeout", self, "on_DashTimer_timeout")
	$LetterTimer.connect("timeout", self, "on_LetterTimer_timeout")
	$WordTimer.connect("timeout", self, "on_WordTimer_timeout")

func _physics_process(_delta):
	if MODE == "battle": interpret_morse()

func on_DashTimer_timeout():
	letter += "-"

func on_LetterTimer_timeout():
	word.append(letter)
	$Player/CPUParticles2D.texture = load("res://Player/Letters/letters_%s.png" % letters[letter])
	$Player/CPUParticles2D.emitting = true
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

