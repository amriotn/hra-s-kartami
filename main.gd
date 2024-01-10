extends Node2D

var player_scene = load("res://Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = player_scene.instantiate()
	add_child(player)
	
	var dicenumber_label = $Camera2D/DiceNumber
	dicenumber_label.connect("send_dice_number", Callable(player, "_on_dice_number_send_dice_number"))
	#button.connect("pressed", Callable(player, "dice_rolled"))
	#await get_tree().create_timer(1).timeout
	#var start_pos_marker = self.get_parent().get_node("StartPosition")
	var start_pos_marker = $StartPosition
	player.position = start_pos_marker.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

"""
func _input(event):
   # Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		print("Mouse Motion at: ", event.position)

	# Print the size of the viewport.
	print("Viewport Resolution is: ", get_viewport_rect().size)
"""
