extends Node2D

var world
var creatures setget set_creatures
var battle
var initial_setup = true
var first_battle = true
var tutorial
var order_required = false
var player setget set_player
var inventory = {"shield":0, "large_potion":0, "medium_potion":0, "small_potion":0} setget set_inventory
var inventory_node setget set_inventory_node
var inventory_nodes = {
	"small_potion":null,
	"medium_potion":null,
	"large_potion":null,
	"shield":null,
}
var xp = 0
var particles
var dash_progress_bar
var invincibility_timer
var MODE = "wander"
var mouse_hovering
var selected_item
var potion_stats = {
	"small": 20,
	"medium": 40,
	"large": 60,
}
var enemy_scenes = {
	"BAT":preload("res://Animals/Stage 1/Bat.tscn"),
	"CAT":preload("res://Animals/Stage 1/Cat.tscn"),
	"DOG":preload("res://Animals/Stage 1/Dog.tscn"),
	"RAT":preload("res://Animals/Stage 1/Rat.tscn"),
	"FISH":preload("res://Animals/Stage 2/Fish.tscn"),
	"TOAD":preload("res://Animals/Stage 2/Toad.tscn"),
	"HARE":preload("res://Animals/Stage 2/Hare.tscn"),
	"SWAN":preload("res://Animals/Stage 2/Swan.tscn"),
	"CAMEL":preload("res://Animals/Stage 3/Camel.tscn"),
	"HYENA":preload("res://Animals/Stage 3/Hyena.tscn"),
	"EAGLE":preload("res://Animals/Stage 3/Eagle.tscn"),
	"SNAKE":preload("res://Animals/Stage 3/Snake.tscn"),
	"WALRUS":preload("res://Animals/Boss/Walrus.tscn")
}
var player_data = {} 
var player_pos = Vector2()
var enemy_world_data = {
	"BAT":[],
	"CAT":[],
	"DOG":[],
	"RAT":[],
	"FISH":[],
	"TOAD":[],
	"HARE":[],
	"SWAN":[],
	"CAMEL":[],
	"HYENA":[],
	"EAGLE":[],
	"SNAKE":[],
	"WALRUS":[]
}
var enemy_battle_data = []

func switch_scene_battle(enemy):
	var enemies = [enemy]
	player.nearby_animals.erase(enemy)
	if enemy in enemy.nearby_animals: enemy.nearby_animals.erase(enemy)
	for e in enemy.nearby_animals:
		if e in player.nearby_animals: player.nearby_animals.erase(e)
	if len(enemy.nearby_animals) >= 2: enemies += enemy.nearby_animals.slice(0, 1) #if there are enough in just the enemy's nearby animals
	elif len(player.nearby_animals) + len(enemy.nearby_animals) >= 2: 
		enemies += enemy.nearby_animals + player.nearby_animals.slice(0, 1 - len(enemy.nearby_animals))
	else: enemies += enemy.nearby_animals + player.nearby_animals #there aren't enough, so it just puts them all in there
	player_data = player.data
	player_pos = player.position
	var animals = get_tree().get_nodes_in_group("animals")
	for animal in animals:
		if not animal in enemies and animal.type != "WALRUS": enemy_world_data[animal.type].append({
			"current_position":animal.global_position,
			"target_position":animal.target_position,
			"start_position":animal.start_position
		})
	enemy_battle_data = []
	for e in enemies:
		enemy_battle_data.append(e.type)
	if enemy.type == "WALRUS": enemy_battle_data = ["WALRUS"]
	get_tree().change_scene("Battle/Battle.tscn")

func switch_scene_world():
	player_data = player.data
	MODE = "wander"
	get_tree().change_scene("World/World.tscn")

func pick_up_potion(size, potion):
	inventory["%s_potion" % size] += 1
	inventory_nodes["%s_potion" % size].get_node("Amount").text = str(inventory["%s_potion" % size])
	battle.potions.erase(potion)
	potion.queue_free()


func on_mouse_entered_item(item):
	selected_item = item
	if Game.tutorial and Game.tutorial.part == "PotionHint": Game.tutorial.on_PotionHint_passed()
	
func on_mouse_exited_item(_item):
	selected_item = null

func use_item():
	if not inventory[selected_item] >= 1: return
	match selected_item:
		"shield":
			pass
		"small_potion":
			player.data.hp = min(player.data.hp + potion_stats.small, player.max_hp)
			inventory[selected_item] -= 1
			inventory_nodes[selected_item].get_node("Amount").text = str(inventory[selected_item])
			inventory_node.get_node("potion_sound").play()
		"medium_potion":
			player.data.hp = min(player.data.hp + potion_stats.medium, player.max_hp)
			inventory[selected_item] -= 1
			inventory_nodes[selected_item].get_node("Amount").text = str(inventory[selected_item])
			inventory_node.get_node("potion_sound").play()
		"large_potion":
			player.data.hp = min(player.data.hp + potion_stats.large, player.max_hp)
			inventory[selected_item] -= 1
			inventory_nodes[selected_item].get_node("Amount").text = str(inventory[selected_item])
			inventory_node.get_node("potion_sound").play()
	player.get_node("HealthBar").value = player.data.hp / player.max_hp
	
func set_player(player_):
	player = player_
	player.data = player_data

func restart():
	initial_setup = true
	player_pos = Vector2()
	MODE = "wander"
	mouse_hovering = null
	get_tree().change_scene("res://World/World.tscn")

func pick_one(options):
	options.shuffle()
	return options[0]

func set_inventory(inventory_):
	inventory = inventory_
	if inventory_node: 
		inventory_nodes.small_potion.get_node("Amount").text = str(inventory.small_potion)
		inventory_nodes.small_potion.get_node("Amount").text = str(inventory.small_potion)
		inventory_nodes.small_potion.get_node("Amount").text = str(inventory.small_potion)

func set_inventory_node(inventory_node_):
	inventory_node = inventory_node_
	for node in inventory_nodes.keys():
		inventory_nodes[node] = inventory_node.get_node("HBoxContainer/%s" % node)
		if node.match("*_potion"): inventory_nodes[node].get_node("Amount").text = str(inventory[node])

func set_creatures(c):
	creatures = c
	for animal_type in enemy_world_data.keys():
		for animal in enemy_world_data[animal_type]:
			var enemy = enemy_scenes[animal_type].instance()
			enemy.position = animal.current_position
			enemy.start_position = animal.start_position
			enemy.target_position = animal.target_position
			creatures.add_child(enemy)
