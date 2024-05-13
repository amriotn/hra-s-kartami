extends Node2D

var player_scene = load("res://scenes/player/Player.tscn")

@onready var end_turn_button : Button = get_tree().get_nodes_in_group("ui_layer")[0].end_turn_button
@onready var player_list_v_box = $MainCamera/GUI/CollapsablePlayerList/PlayersScrollBar/PlayerListVBox
@onready var gui = $MainCamera/GUI
@onready var main_camera = $MainCamera


var cam_tween : Tween
var game : bool
var player_list : Array
var turn_of_player : int
var turn = 1
@onready var actions_of_tiles : ActionsOfTiles = $ActionsOfTiles
@onready var bazina_way_there = $ActionsOfTiles/BazinaWayThere
@onready var bazina_way_back = $ActionsOfTiles/BazinaWayBack




func _ready():
	DisplayServer.window_set_min_size(Vector2(800, 600))
	#var dice_animated_sprite = $MainCamera/GUI/CenterContainer/DiceControl/DiceAnimatedSprite
	Global.player_list = player_list
	
	var tile_node : TileMap = self.get_node("TileMap")
	var start_pos_marker : Marker2D = $StartPosition
	# sets position of StartPosition marker to the center of the desired starting tile
	start_pos_marker.position = tile_node.map_to_local(tile_node.local_to_map(start_pos_marker.position))
	#print(tile_node.local_to_map(start_pos_marker.position))
	
	
	if not Global.player_stats_resources.is_empty():
		var player_pos = Vector2i(0.0, 0.0)
		for stat in Global.player_stats_resources:
			var player = player_scene.instantiate()
			player.load_stats(stat)
			add_child(player)
			player.position = player_pos
			player_pos.x += 120.0
			player.self_modulate = stat.player_color
			player.texture = load(stat.player_character)
			# when dice is rolled, sends the number to player
			#dice_animated_sprite.connect("send_dice_number", Callable(player, "_on_dice_animated_sprite_send_dice_number"))
			
			# sets player position to the start
			player.position = start_pos_marker.position
			
			player_list.append(player)
			
	
	
	await get_tree().create_timer(0.5).timeout
	fix_players_on_tile(Global.player_list)
	Global.update_stats()
	
	var player_hands = []
	for player in player_list:
		gui.add_child(player.stats.hand)
		player_hands.append(player.stats.hand)
		player.stats.hand.hide()
	
	
	
	
	
	var finished_players_sum : int
	game = true
	turn_of_player = 0
	gui.timer_on = true
	while game:
		if Global.player_list[turn_of_player].stats.has_finished == false:
			gui.end_turn_button.disabled = true
			player_hands[turn_of_player].show()
			
			if Global.player_list[turn_of_player].swamp_route_swap:
				actions_of_tiles.swamp = actions_of_tiles.bazina_way_back
			else:
				actions_of_tiles.swamp = actions_of_tiles.bazina_way_there
			
			main_camera.position = Global.player_list[turn_of_player].position
			
			Global.player_list[turn_of_player].roll_dice_button.disabled = false
			
			player_list_v_box.get_children()[turn_of_player].select_gradient.show()
			
			Global.player_list[turn_of_player].dice_animated_sprite.show()
			Global.player_list[turn_of_player].dice_animated_sprite.connect("send_dice_number", Callable(Global.player_list[turn_of_player], "_on_dice_animated_sprite_send_dice_number"))
			fix_players_on_tile(Global.player_list)
			
			
			
			await end_turn_button.pressed
			player_hands[turn_of_player].hide()
			Global.player_list[turn_of_player].dice_animated_sprite.disconnect("send_dice_number", Callable(Global.player_list[turn_of_player], "_on_dice_animated_sprite_send_dice_number"))
			Global.player_list[turn_of_player].dice_animated_sprite.hide()
			player_list_v_box.get_children()[turn_of_player].select_gradient.hide()
			
			
			if Global.player_list[turn_of_player].stats.has_finished == false:
				if Global.player_list.size() > 0:
					if turn_of_player +1 >= Global.player_list.size():
						turn_of_player = 0
						turn += 1
						gui.round_label.text = "Kolo " + str(turn)
					else:
						turn_of_player += 1
				else:
					game = false
			else:
				finished_players_sum += 1
				if finished_players_sum == Global.player_list.size():
					game = false
		else:
			if Global.player_list.size() > 0:
					if turn_of_player +1 >= Global.player_list.size():
						turn_of_player = 0
						turn += 1
						gui.round_label.text = "Kolo " + str(turn)
					else:
						turn_of_player += 1
			if finished_players_sum == Global.player_list.size():
					game = false
		
	
	gui.end_game_panel.show()
		
		
	
func fix_players_on_tile(player_list):
	var tilemap_node : TileMap = self.get_node("TileMap")
	
	var players_on_tile = []
	for player in player_list:
		for area in player.player_finder.get_overlapping_areas():
			if area.collision_layer == 2:
				if not players_on_tile.has(player):
					players_on_tile.append(player)
				#print(area)
	
	#print(players_on_tile)
	
	#players_on_tile.append(self)
	#print(players_on_tile)
	if players_on_tile:
		var first_pos_help = 200.0/float(players_on_tile.size())
		var first_pos = first_pos_help/2.0
		var i = 0
		for player in players_on_tile:
			player.position = tilemap_node.map_to_local(tilemap_node.local_to_map(player.position))
			player.position.x -= 100
			player.position.x += first_pos + i*first_pos_help
			#print(player.position.x)
			i += 1
	
	
	
	
