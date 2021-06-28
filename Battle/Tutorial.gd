extends Control

var part = "DoTutorial"

func on_DoTutorial_Yes_pressed():
	$DoTutorial.visible = false
	Game.tutorial = self
	$EnemyNameHint.visible = true
	part = "EnemyNameHint"
	
func on_DoTutorial_No_pressed():
	visible = false
	get_tree().paused = false

func on_EnemyNameHint_passed():
	$EnemyNameHint.visible = false
	$DashBarHint.visible = true
	part = "DashBarHint"

func on_DashBarHint_passed():
	$DashBarHint.visible = false
	$PotionHint.visible = true
	part = "PotionHint"

func on_PotionHint_passed():
	$PotionHint.visible = false
	$HealthHint.visible = true
	part = "HealthHint"

func on_HealthHint_passed():
	$HealthHint.visible = false
	$XPHint.visible = true
	part = "XPHint"

func on_XPHint_passed():
	visible = false
	Game.tutorial = null
	get_tree().paused = false

func _on_DashBar_mouse_entered():
	if Game.tutorial and part == "DashBarHint": on_DashBarHint_passed()

func _on_HealthBar_mouse_entered():
	if Game.tutorial and part == "HealthHint": on_HealthHint_passed()

func _on_XPBar_mouse_entered():
	if Game.tutorial and part == "XPHint": on_XPHint_passed()
