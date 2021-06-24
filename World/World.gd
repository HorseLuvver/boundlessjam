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
	Game.animals = $YSort/Creatures.get_children()
	
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
				var animals = []
				for animal in Game.enemy_scenes.keys():
					if len(animal) == 3: animals.append(animal)
				animals.shuffle()
				var animal = animals[0]
				animal = Game.enemy_scenes[animal].instance()
				animal.position = $Stage1Spawner.position + Vector2(rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE), rand_range(-animal.SPAWNING_RANGE, animal.SPAWNING_RANGE))
				$YSort/Creatures.add_child(animal)
				Game.animals.append(animal)



