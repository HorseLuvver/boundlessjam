extends "../Animal.gd"


func _ready():
	add_to_group("animals/stage 3")
	set_positions(global_position)
	type = "EAGLE"
	moves = ["jab"]
	move_anim_name = "fly"
	
