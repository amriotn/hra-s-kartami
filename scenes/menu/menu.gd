extends Control

@onready var player_list_scroll_container = $LeftSide/PlayerListScrollContainer
@onready var v_box_container = $LeftSide/PlayerListScrollContainer/VBoxContainer

@onready var player_showcase = $LeftSide/PlayerListScrollContainer/VBoxContainer/PlayerShowcase

const PLAYER_SHOWCASE = preload("res://scenes/player_showcase/player_showcase.tscn")

var player_count : int
var player_list

func _ready():
	player_count = v_box_container.get_children().count(player_showcase)
	add_player_to_list()


func _on_add_player_button_pressed():
	add_player_to_list()


func add_player_to_list():
	var player_item = PLAYER_SHOWCASE.instantiate()
	v_box_container.add_child(player_item)
	player_count += 1
	player_item.player_order.text = str(player_count)+"#"
	player_item.nickname.text = "Hráč"+str(player_count)
	player_item.color.color = Color.WHITE
	player_item.delete_button.pressed.connect(_on_player_item_delete_button_pressed.bind(player_item))


func _on_player_item_delete_button_pressed(player_item):
	player_item.queue_free()
	await player_item.tree_exited
	player_count -= 1
	player_list = v_box_container.get_children()
	
	var item_pos = 0
	for item in player_list:
		item_pos+=1
		if item.player_order.text.left(-1) != str(item_pos):
			item.player_order.text = str(item_pos) + "#"



func _on_start_game_button_pressed():
	player_list = v_box_container.get_children()
	if not player_list.is_empty():
		for player in player_list:
			Global.player_stats_resources.append(PlayerStats.new(player.nickname.text, player.color.color, player.player_icon_index))
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
