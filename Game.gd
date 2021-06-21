extends Node2D

var world
var player setget set_player_data
var particles
var dash_progress_bar
var animals = []
var MODE = "wander"
var player_data = {
	"hp":100
}
var player_pos
var enemy_world_data = {
	"Bat":[],
	"Cat":[],
	"Dog":[],
	"Rat":[],
	"Fish":[],
	"Frog":[],
	"Newt":[],
	"Swan":[],
	"Camel":[],
	"Gecko":[],
	"Eagle":[],
	"Snake":[]
}
var enemy_battle_data

func switch_scene_battle(enemy):
	var enemies = [enemy]
	player.nearby_animals.erase(enemy)
	for e in enemy.nearby_animals:
		if e in player.nearby_animals: player.nearby_animals.erase(e)
	if len(enemy.nearby_animals) >= 2: enemies += enemy.nearby_animals.slice(0, 1)
	elif len(player.nearby_animals) + len(enemy.nearby_animals) >= 2: enemies += enemy.nearby_animals + player.nearby_animals.slice(0, 1 - len(enemy.nearby_animals))
	else: enemies += enemy.nearby_animals + player.nearby_animals
	player_data = player.data
	player_pos = player.global_position
	for animal in animals:
		if not animal in enemies:
			enemy_world_data[animal.type].append({
				"current_position":animal.global_position,
				"target_position":animal.target_position,
				"start_position":animal.start_position
			})
	enemy_battle_data = []
	for e in enemies:
		enemy_battle_data.append(e.type)
	get_tree().change_scene("Battle/Battle.tscn")

func set_player_data(player_):
	player = player_
	player.data = player_data
