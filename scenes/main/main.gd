extends Node2D

var player_scene = load("res://scenes/player/Player.tscn")

func _ready():
	# adds player to the scene tree
	var player = player_scene.instantiate()
	add_child(player)
	
	# when dice is rolled, sends the number to player
	var dicenumber_label = $MainCamera/GUI/CenterContainer/DiceControl/DiceNumber
	dicenumber_label.connect("send_dice_number", Callable(player, "_on_dice_number_send_dice_number"))
	
	
	var tile_node : TileMap = self.get_node("TileMap")
	var start_pos_marker : Marker2D = $StartPosition
	# sets position of StartPosition marker to the center of the desired starting tile
	start_pos_marker.position = tile_node.map_to_local(tile_node.local_to_map(start_pos_marker.position))
	# sets player position to the start
	player.position = start_pos_marker.position
	
	
