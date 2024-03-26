extends Node2D

var player_scene = load("res://scenes/player/Player.tscn")

func _ready():
	"""
	var game = true
	while game:
		for player in player_list:
			#round last until player finishes
	"""
	var dice_animated_sprite = $MainCamera/GUI/CenterContainer/DiceControl/DiceAnimatedSprite
	
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
			player.modulate = stat.player_color
			# when dice is rolled, sends the number to player
			dice_animated_sprite.connect("send_dice_number", Callable(player, "_on_dice_animated_sprite_send_dice_number"))
			
			# sets player position to the start
			player.position = start_pos_marker.position
	else:
		# adds player to the scene tree
		var player = player_scene.instantiate()
		add_child(player)
		# when dice is rolled, sends the number to player
		dice_animated_sprite.connect("send_dice_number", Callable(player, "_on_dice_animated_sprite_send_dice_number"))
		
		# sets player position to the start
		player.position = start_pos_marker.position
		
	
	
	
	
	
	
