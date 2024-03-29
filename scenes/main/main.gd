extends Node2D

var player_scene = load("res://scenes/player/Player.tscn")

@onready var end_turn_button : Button = get_tree().get_nodes_in_group("ui_layer")[0].end_turn_button
@onready var player_list_v_box = $MainCamera/GUI/CollapsablePlayerList/PlayersScrollBar/PlayerListVBox
@onready var gui = $MainCamera/GUI

var game : bool
var player_list : Array
var turn_of_player : int
var turn = 1

func _ready():
	#var dice_animated_sprite = $MainCamera/GUI/CenterContainer/DiceControl/DiceAnimatedSprite
	
	var tile_node : TileMap = self.get_node("TileMap")
	var start_pos_marker : Marker2D = $StartPosition
	# sets position of StartPosition marker to the center of the desired starting tile
	start_pos_marker.position = tile_node.map_to_local(tile_node.local_to_map(start_pos_marker.position))
	print(tile_node.local_to_map(start_pos_marker.position))
	
	
	if not Global.player_stats_resources.is_empty():
		var player_pos = Vector2i(0.0, 0.0)
		for stat in Global.player_stats_resources:
			var player = player_scene.instantiate()
			player.load_stats(stat)
			add_child(player)
			player.position = player_pos
			player_pos.x += 120.0
			player.self_modulate = stat.player_color
			# when dice is rolled, sends the number to player
			#dice_animated_sprite.connect("send_dice_number", Callable(player, "_on_dice_animated_sprite_send_dice_number"))
			
			# sets player position to the start
			player.position = start_pos_marker.position
			player_list.append(player)
		
			
	else:
		# adds player to the scene tree
		var player = player_scene.instantiate()
		add_child(player)
		# when dice is rolled, sends the number to player
		#dice_animated_sprite.connect("send_dice_number", Callable(player, "_on_dice_animated_sprite_send_dice_number"))
		
		# sets player position to the start
		player.position = start_pos_marker.position
		player_list.append(player)
		
	game = true
	turn_of_player = 0
	gui.timer_on = true
	while game:
		player_list[turn_of_player].roll_dice_button.disabled = false
		
		player_list_v_box.get_children()[turn_of_player].select_gradient.show()
		
		player_list[turn_of_player].dice_animated_sprite.show()
		player_list[turn_of_player].dice_animated_sprite.connect("send_dice_number", Callable(player_list[turn_of_player], "_on_dice_animated_sprite_send_dice_number"))
		await end_turn_button.pressed
		player_list[turn_of_player].dice_animated_sprite.disconnect("send_dice_number", Callable(player_list[turn_of_player], "_on_dice_animated_sprite_send_dice_number"))
		player_list[turn_of_player].dice_animated_sprite.hide()
		player_list_v_box.get_children()[turn_of_player].select_gradient.hide()
		if turn_of_player +1 == player_list.size():
			turn_of_player = 0
			turn += 1
			gui.round_label.text = "Kolo " + str(turn)
		else:
			turn_of_player += 1
		
		
	
	
	
	
	
	
