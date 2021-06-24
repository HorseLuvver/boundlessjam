extends KinematicBody2D

export (int) var SPEED
export (float) var max_hp = 1
var switch_animation
onready var data = {
	"hp":max_hp,
}
var nearby_animals = []

func _ready():
	randomize()
	$AnimatedSprite.connect("animation_finished", self, "on_animation_finished")
	$DetectionRange.connect("body_entered", self, "on_body_entered")
	$DetectionRange.connect("body_exited", self, "on_body_exited")
	
func _physics_process(_delta):
	if Game.MODE == "wander": move()

func move():
	if Input.is_action_pressed("button") and global_position.distance_to(get_global_mouse_position()) > 5:
		move_and_slide(global_position.direction_to(get_global_mouse_position()) * SPEED)
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = global_position.direction_to(get_global_mouse_position()).x < 0
		$AnimatedSprite/IdleTimer.stop()
		$AnimatedSprite/IdleTimer.start(0.25)
	elif $AnimatedSprite/IdleTimer.is_stopped(): $AnimatedSprite.play("idle")

func on_body_entered(body):
	if body.is_in_group("Animals"): nearby_animals.append(body)

	
func on_body_exited(body):
	if body.is_in_group("Animals"): nearby_animals.erase(body)

func on_animation_finished():
	if switch_animation: 
		$AnimatedSprite.play(switch_animation)
		switch_animation = null
