extends Node2D

var player_scene = load("res://scenes/player/Player.tscn")

func _ready():
	# adds player to the scene tree
	var player = player_scene.instantiate()
	add_child(player)
	
	# when dice is rolled, sends the number to player
	var dicenumber_label = $MainCamera/GUI/CenterContainer/DiceControl/DiceNumber
	dicenumber_label.connect("send_dice_number", Callable(player, "_on_dice_number_send_dice_number"))
	
	# sets player position to the start
	var start_pos_marker = $StartPosition
	player.position = start_pos_marker.position
