extends Sprite2D

var highlight_scene : PackedScene = load("res://Highlight.tscn")

var dice_number : int = 0
var markers : Array = []

var highlights : Array = []

#var tile_node = self.get_parent().get_node("TileMap")
#var first_tile_pos = tile_node.get_used_cells(0)[0]

func _ready():
	markers = [$NorthMarker, $SouthMarker, $EastMarker, $WestMarker]
	print(position)
	print(markers)

"""
#func _on_roll_dice_button_pressed():
func dice_rolled():
	#var markers = [get_node("NorthMarker"), get_node("SouthMarker"), get_node("EastMarker"), get_node("WestMarker")]
	print("rolled " + str(dice_number))
	var tile_node = self.get_parent().get_node("TileMap")
	check_surrond_tiles_existence()
	
	for direction in markers:
		if tile_node.get_cell_source_id(1, direction.position):
			
		
			var highlight = highlight_scene.instantiate()
			add_child(highlight)
			highlight.position = get_node("EastMarker").position
"""

func _on_dice_number_send_dice_number(number):
	dice_number = number
	print("rolled " + str(dice_number))
	
	var tilemap_node : TileMap = self.get_parent().get_node("TileMap")
	#check_surrond_tiles_existence()
	
	#var player_surrounds = tilemap_node.get_surrounding_cells(tilemap_node.local_to_map(self.position))
	var reference_tile = tilemap_node.local_to_map(self.position)
	#print(reference_tile)
	check_surrond_tiles_help(reference_tile, reference_tile, dice_number)
	

func check_surrond_tiles_help(center_tile : Vector2i, previous_tile : Vector2i, dice_number : int):
	var tilemap_node : TileMap = self.get_parent().get_node("TileMap")
	var current_surrounds : Array = tilemap_node.get_surrounding_cells(center_tile)
	print("Tile ", center_tile, "surronds: ", current_surrounds,"\ndice:", dice_number)
	if dice_number > 0:
		for tile in current_surrounds:
			if tile == previous_tile:
				print("equals")
			else:
				if tilemap_node.get_cell_source_id(0, tile) == 0: # = tile exists
					print("Tile:", tile, "exists")
					check_surrond_tiles_help(tile, center_tile, dice_number-1)
				else:
					print("Tile:", tile, "does NOT exist")
	elif dice_number <= 0:
		print("\bReference tile: ", center_tile)
		var highlight = highlight_scene.instantiate()
		tilemap_node.add_child(highlight)
		highlight.position = tilemap_node.map_to_local(center_tile)
		highlight.z_index = 5
		highlight.connect("send_highlight_position", Callable(self, "_on_highlight_send_highlight_position"))
		highlights.append(highlight)
		
func _on_highlight_send_highlight_position(highlight_position):
	self.position = highlight_position
	for highlight in highlights:
		highlight.queue_free()
	highlights.clear()
