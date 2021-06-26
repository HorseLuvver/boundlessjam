extends "../Animal.gd"


func _ready():
	add_to_group("animals/stage 2")
	set_positions(global_position)
	type = "HARE"
	moves = ["claw"]
	move_anim_name = "hop"
	strength = 1.5
