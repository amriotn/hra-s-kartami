extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#print(cell_quadrant_size)
	#print(tile_set.get_source(0))
	#print(get_used_cells(0))
	#print(get_used_cells_by_id(0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
	
func _input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("left_click"):
			var global_clicked = event.position
			var tile_clicked = local_to_map(to_local(global_clicked))
			print(tile_clicked)
