extends Node2D

export (int) var MAX_ANIMALS
export (int) var MAX_STAGE_1_ANIMALS
export (int) var MAX_STAGE_2_ANIMALS
export (int) var MAX_STAGE_3_ANIMALS
export (int) var MIN_DISTANCE
export (int) var MAX_DISTANCE

func _ready():
	Game.world = self
	$YSort/Player.position = Game.player_pos
	if Game.initial_setup: Game.player_data = $YSort/Player.data
	Game.player = $YSort/Player
	Game.particles = $YSort/Player/CPUParticles2D
	
	for animal_type in Game.enemy_world_data.keys():
		for animal in Game.enemy_world_data[animal_type]:
			var enemy = Game.enemy_scenes[animal_type].instance()
			enemy.position = animal.current_position
			enemy.start_position = animal.start_position
			enemy.target_position = animal.target_position
			$YSort/Creatures.add_child(enemy)
	
	Game.initial_setup = false

func on_SpawnTimer_timeout(stage):
	if len(get_tree().get_nodes_in_group("animals")) >= MAX_ANIMALS: return
	match stage:
		1:
			if $Stage1Spawner.position.distance_to($YSort/Player.position) > MIN_DISTANCE and len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS:
				var animals = ["BAT", "RAT", "CAT", "DOG"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage1Spawner.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
			if $Stage1Spawner2.position.distance_to($YSort/Player.position) > MIN_DISTANCE and len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS:
				var animals = ["BAT", "RAT", "CAT", "DOG"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage1Spawner2.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
		2:
			if $Stage2SpawnerWater.position.distance_to($YSort/Player.position) > MIN_DISTANCE and len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS:
				var animals = ["SWAN", "FISH"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage2SpawnerWater.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
			if $Stage2SpawnerLand.position.distance_to($YSort/Player.position) > MIN_DISTANCE and len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS:
				var animals = ["SWAN", "HARE", "TOAD"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage2SpawnerLand.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
		3:
			if $Stage3Spawner.position.distance_to($YSort/Player.position) > MIN_DISTANCE and len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS:
				var animals = ["CAMEL", "EAGLE", "SNAKE", "HYENA"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage3Spawner.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
			if $Stage3Spawner2.position.distance_to($YSort/Player.position) > MIN_DISTANCE and len(get_tree().get_nodes_in_group("animals/stage 1")) < MAX_STAGE_1_ANIMALS:
				var animals = ["CAMEL", "EAGLE", "SNAKE", "HYENA"]
				var animal = Game.pick_one(animals)
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage3Spawner2.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
		_:
			pass

