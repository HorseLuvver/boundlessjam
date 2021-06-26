extends "../Animal.gd"


func _ready():
	add_to_group("animals/stage 2")
	set_positions(global_position)
	type = "FISH"
	moves = ["pounce"]
	move_anim_name = "swim"
	strength = 1.5
