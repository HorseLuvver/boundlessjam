extends "../Animal.gd"

func _ready():
	set_positions(global_position)
	type = "Bat"
	moves = ["bite"]
