extends "../Animal.gd"


func _ready():
	add_to_group("animals/stage 2")
	set_positions(global_position)
	type = "TOAD"
	moves = ["pounce"]
	move_anim_name = "jump"
	strength = 1.5
