extends Control




func _on_RequireOrder_toggled(button_pressed):
	Game.order_required = button_pressed


func _on_ButtonSelect_item_selected(index):
	var button = $MarginContainer/VBoxContainer/VBoxContainer/ButtonSelect.get_item_text(index)
	var space = InputEventKey.new()
	space.scancode = KEY_SPACE
	var mouse = InputEventMouseButton.new()
	mouse.button_index = BUTTON_LEFT
	match button:
		"Left Mouse Button":
			InputMap.action_erase_event("button", space)
			InputMap.action_add_event("button", mouse)
		"Space":
			InputMap.action_erase_event("button", mouse)
			InputMap.action_add_event("button", space)
			


func _on_BackButton_pressed():
	get_tree().change_scene("res://UI/TitleScreen.tscn")
