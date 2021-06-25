extends "../Animal.gd"


func _ready():
	add_to_group("animals/stage 2")
	set_positions(global_position)
	type = "SWAN"
	moves = ["jab"]
	move_anim_name = "fly"
