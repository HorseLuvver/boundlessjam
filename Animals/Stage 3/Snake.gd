extends "../Animal.gd"


func _ready():
	add_to_group("animals/stage 3")
	set_positions(global_position)
	type = "SNAKE"
	moves = ["bite"]
	move_anim_name = "slither"
	strength = 2
