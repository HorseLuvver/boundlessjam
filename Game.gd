extends Node2D

var world
var battle
var initial_setup = true
var player setget set_player
var particles
var dash_progress_bar
var animals = []
var MODE = "wander"
var mouse_hovering
var enemy_scenes = {
	"BAT":preload("res://Animals/Stage 1/Bat.tscn"),
	"CAT":preload("res://Animals/Stage 1/Cat.tscn"),
	"DOG":preload("res://Animals/Stage 1/Dog.tscn"),
	"RAT":preload("res://Animals/Stage 1/Rat.tscn"),
	"FISH":[],
	"FROG":[],
	"NEWT":[],
	"SWAN":[],
	"CAMEL":[],
	"GECKO":[],
	"EAGLE":[],
	"SNAKE":[],
	"WALRUS":[]
}
var player_data = {} 
var player_pos = Vector2()
var enemy_world_data = {
	"BAT":[],
	"CAT":[],
	"DOG":[],
	"RAT":[],
	"FISH":[],
	"FROG":[],
	"NEWT":[],
	"SWAN":[],
	"CAMEL":[],
	"GECKO":[],
	"EAGLE":[],
	"SNAKE":[],
	"WALRUS":[]
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
	print(enemy_battle_data)
	get_tree().change_scene("Battle/Battle.tscn")

func switch_scene_world():
	player_data = player.data
	MODE = "wander"
	get_tree().change_scene("World/World.tscn")


func set_player(player_):
	player = player_
	player.data = player_data
