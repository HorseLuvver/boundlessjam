extends "../Animal.gd"


func _ready():
	add_to_group("animals/stage 1")
	set_positions(global_position)
	type = "BAT"
	moves = ["jab"]
	move_anim_name = "fly"
