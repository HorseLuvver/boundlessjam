extends Control

func _ready():
	$Button.connect("pressed", Game, "restart")
	

