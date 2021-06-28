extends Control

func _on_StartButton_pressed():
	get_tree().change_scene("res://World/World.tscn")

func _on_OptionButton_pressed():
	get_tree().change_scene("res://UI/Options.tscn")
