extends KinematicBody2D

export (int) var hp = 50
export (int) var attack_power = 5
export (int) var speed = 75

func pick_new_random_point(current_position):
	return current_position + Vector2(rand_range(-50, 50), rand_range(-50, 50))

