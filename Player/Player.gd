extends KinematicBody2D

export (int) var SPEED
export (int) var max_hp
var data = {
	"hp":max_hp,
}
var nearby_animals = []

func _ready():
	randomize()
	$DetectionRange.connect("body_entered", self, "on_body_entered")
	$DetectionRange.connect("body_exited", self, "on_body_exited")
	Game.world = get_parent()
	Game.player = self
	Game.particles = $CPUParticles2D
	
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

