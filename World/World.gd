extends Node2D

var MAX_ANIMALS = 20
var MAX_STAGE_1_ANIMALS = 10
var MAX_STAGE_2_ANIMALS = 8
var MAX_STAGE_3_ANIMALS = 6
var MIN_DISTANCE = 100
var MAX_DISTANCE = 500

func _ready():
	Game.world = self
	$YSort/Player.position = Game.player_pos
	if Game.initial_setup: Game.player_data = $YSort/Player.data
	Game.player = $YSort/Player
	Game.particles = $YSort/Player/CPUParticles2D
	Game.inventory_node = $YSort/Player/Camera2D/Inventory
	Game.inventory_nodes.small_potion.connect("mouse_entered", Game, "on_mouse_entered_item", ["small_potion"])
	Game.inventory_nodes.small_potion.connect("mouse_exited", Game, "on_mouse_exited_item", ["small_potion"])
	Game.inventory_nodes.medium_potion.connect("mouse_entered", Game, "on_mouse_entered_item", ["medium_potion"])
	Game.inventory_nodes.medium_potion.connect("mouse_exited", Game, "on_mouse_exited_item", ["medium_potion"])
	Game.inventory_nodes.large_potion.connect("mouse_entered", Game, "on_mouse_entered_item", ["large_potion"])
	Game.inventory_nodes.large_potion.connect("mouse_exited", Game, "on_mouse_exited_item", ["large_potion"])
	$YSort/Player/HealthBar.value = $YSort/Player.data.hp / $YSort/Player.max_hp
	for animal_type in Game.enemy_world_data.keys():
		for animal in Game.enemy_world_data[animal_type]:
			var enemy = Game.enemy_scenes[animal_type].instance()
			enemy.position = animal.current_position
			enemy.start_position = animal.start_position
			enemy.target_position = animal.target_position
			$YSort/Creatures.add_child(enemy)
	print(len(get_tree().get_nodes_in_group("animals")))
	Game.initial_setup = false

func _physics_process(delta):
	if Game.selected_item and Input.is_action_just_pressed("button"): Game.use_item()

func on_SpawnTimer_timeout(stage):
	if len(get_tree().get_nodes_in_group("animals")) >= MAX_ANIMALS: return
	match stage:
		1:
			if ($Stage1Spawner.position.distance_to($YSort/Player.position) > MIN_DISTANCE) and ($Stage1Spawner.position.distance_to($YSort/Player.position) < MAX_DISTANCE) and (len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS):
				var animals = ["BAT", "RAT", "CAT", "DOG"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage1Spawner.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
				print(stage, ":", len(get_tree().get_nodes_in_group("animals/stage 1")))
			elif ($Stage1Spawner2.position.distance_to($YSort/Player.position) > MIN_DISTANCE) and ($Stage1Spawner2.position.distance_to($YSort/Player.position) < MAX_DISTANCE) and (len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS):
				var animals = ["BAT", "RAT", "CAT", "DOG"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage1Spawner2.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
				print(stage, ":", len(get_tree().get_nodes_in_group("animals/stage 1")))
		2:
			if ($Stage2SpawnerWater.position.distance_to($YSort/Player.position) > MIN_DISTANCE) and ($Stage2SpawnerWater.position.distance_to($YSort/Player.position) < MAX_DISTANCE) and (len(get_tree().get_nodes_in_group("animals/stage 2")) < MAX_STAGE_2_ANIMALS):
				var animals = ["SWAN", "FISH"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage2SpawnerWater.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
				print(stage, ":", len(get_tree().get_nodes_in_group("animals/stage 2")))
			elif ($Stage2SpawnerLand.position.distance_to($YSort/Player.position) > MIN_DISTANCE) and ($Stage2SpawnerLand.position.distance_to($YSort/Player.position) < MAX_DISTANCE) and (len(get_tree().get_nodes_in_group("animals/stage 2")) < MAX_STAGE_2_ANIMALS):
				var animals = ["SWAN", "HARE", "TOAD"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage2SpawnerLand.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
				print(stage, ":", len(get_tree().get_nodes_in_group("animals/stage 2")))
		3:
			if ($Stage3Spawner.position.distance_to($YSort/Player.position) > MIN_DISTANCE) and ($Stage3Spawner.position.distance_to($YSort/Player.position) < MAX_DISTANCE) and (len(get_tree().get_nodes_in_group("animals/stage 3")) < MAX_STAGE_3_ANIMALS):
				var animals = ["CAMEL", "EAGLE", "SNAKE", "HYENA"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage3Spawner.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
				print(stage, ":", len(get_tree().get_nodes_in_group("animals/stage 3")))
			elif ($Stage3Spawner2.position.distance_to($YSort/Player.position) > MIN_DISTANCE) and ($Stage3Spawner2.position.distance_to($YSort/Player.position) < MAX_DISTANCE) and (len(get_tree().get_nodes_in_group("animals/stage 3")) < MAX_STAGE_3_ANIMALS):
				var animals = ["CAMEL", "EAGLE", "SNAKE", "HYENA"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage3Spawner2.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
				print(stage, ":", len(get_tree().get_nodes_in_group("animals/stage 3")))

