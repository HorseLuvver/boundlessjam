extends KinematicBody2D

export (int) var SPEED
onready var game = get_parent()

func _physics_process(delta):
	if game.MODE == "wander": move()

func move():
	if Input.is_action_pressed("button") and global_position.distance_to(get_global_mouse_position()) > 20:
		move_and_slide(global_position.direction_to(get_global_mouse_position()) * SPEED)
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = global_position.direction_to(get_global_mouse_position()).x < 0
		$AnimatedSprite/IdleTimer.stop()
		$AnimatedSprite/IdleTimer.start(0.25)
	elif $AnimatedSprite/IdleTimer.is_stopped(): $AnimatedSprite.play("idle")
