extends KinematicBody2D

export (int) var SPAWNING_RANGE = 300
export (int) var WANDER_RANGE = 50
export (int) var attack_power = 5
export (int) var speed = 40
signal attack
var STATE = "wander"
var move_anim_name = "walk"
var moves = []
var letters = {}
var type
var player
var target_position = position
var start_position = position
var nearby_animals = []
var switch_animation

func _ready():
	add_to_group("animals")
	pick_new_target_position()
	$AnimatedSprite.connect("animation_finished", self, "on_animation_finished")
	$FightZone.connect("body_entered", self, "FightZone_on_body_entered")
	$FightZone.connect("body_exited", self, "FightZone_on_body_exited")
	$ChaseZone.connect("body_entered", self, "ChaseZone_on_body_entered")
	$ChaseZone.connect("body_exited", self, "ChaseZone_on_body_exited")
	$WanderTimer.connect("timeout", self, "on_WanderTimer_timeout")
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	var state_change_timer = Timer.new()
	add_child(state_change_timer)
	state_change_timer.one_shot = true
	state_change_timer.autostart = true
	state_change_timer.name = "StateChangeTimer"
	for letter in name.to_upper():
		letters[letter] = false

func _physics_process(delta):
	var velocity = Vector2()
	match STATE:
		"idle":
			$AnimatedSprite.play("idle")
			if $StateChangeTimer.is_stopped(): 
				STATE = Game.pick_one(["idle", "wander"])
				$StateChangeTimer.start(rand_range(1, 3))
		"wander":
			$AnimatedSprite.play(move_anim_name)
			if position.distance_to(target_position) > 10: velocity = position.direction_to(target_position) * speed
			else: STATE = "idle"
			if $StateChangeTimer.is_stopped(): 
				STATE = Game.pick_one(["idle", "wander"])
				$StateChangeTimer.start(rand_range(1, 3))
			
		"chase":
			$AnimatedSprite.play(move_anim_name)
			if player != null: velocity = position.direction_to(player.position) * speed
	$AnimatedSprite.flip_h = velocity.x < 0
	move_and_slide(velocity)

func pick_new_target_position():
	target_position = start_position + Vector2(rand_range(-WANDER_RANGE, WANDER_RANGE), rand_range(-WANDER_RANGE, WANDER_RANGE))

func FightZone_on_body_entered(body):
	if body.name == "Player": 
		Game.MODE = "battle"
		Game.switch_scene_battle(self)

func FightZone_on_body_exited(body):
	#if body.is_in_group("animals"): nearby_animals.erase(body)
	pass

func ChaseZone_on_body_entered(body):
	if body.name == "Player":
		STATE = "chase"
		player = body
	elif body.is_in_group("animals"):
		nearby_animals.append(body)

func ChaseZone_on_body_exited(body):
	if body.name == "Player":
		STATE = "wander"
		player = null
	elif body.is_in_group("animals"):
		nearby_animals.erase(body)

func set_positions(current_position):
	start_position = current_position
	target_position = current_position

func letter_recieved(letter):
	if letter in name.to_upper() and Game.mouse_hovering == self:
		letters[letter] = true
		get_node("../Name/MarginContainer/HBoxContainer/%s" % letter).hide()
		if all(letters.values()): 
			get_node("../Name").hide()
			Game.battle.enemies.erase(self)
			queue_free()
		 
func all(list):
	for item in list:
		if item == false:
			return false
	return true

func on_mouse_entered():
	if Game.mouse_hovering: Game.mouse_hovering.hide_selection_box()
	Game.mouse_hovering = self
	$AnimalSelectionBox.visible = true

func hide_selection_box():
	$AnimalSelectionBox.visible = false
func on_mouse_exited():
	pass

func attack(move):
	emit_signal("attack", move)
	$AnimatedSprite.play(move)
	switch_animation = "idle"

func on_AttackTimer_timeout():
	attack(moves[0])

	
func on_WanderTimer_timeout():
	if Game.MODE == "wander": pick_new_target_position()

func on_animation_finished():
	if switch_animation: 
		$AnimatedSprite.play(switch_animation)
		switch_animation = null
