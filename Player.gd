extends Sprite2D

var highlight_scene = load("res://Highlight.tscn")
#var markers = [self.get_node("NorthMarker"), self.get_node("SouthMarker"), self.get_node("EastMarker"), self.get_node("WestMarker")]

var dice_number = 0
var markers = []

#var tile_node = self.get_parent().get_node("TileMap")
#var first_tile_pos = tile_node.get_used_cells(0)[0]

func _ready():
	markers = [$NorthMarker, $SouthMarker, $EastMarker, $WestMarker]
	"""var tile_node = self.get_parent().get_node("TileMap")
	var first_tile_pos = tile_node.get_used_cells(0)[0]
	position = tile_node.map_to_local(first_tile_pos)
	print(position)
	await get_tree().create_timer(1).timeout
	var start_pos_marker = self.get_parent().get_node("StartPosition")
	self.position = start_pos_marker.position"""
	print(position)
	print(markers)


func when_dice_button_pressed():
	#var markers = [get_node("NorthMarker"), get_node("SouthMarker"), get_node("EastMarker"), get_node("WestMarker")]
	print("rolled " + str(dice_number))
	var tile_node = self.get_parent().get_node("TileMap")
	check_surrond_tiles_existence()
	"""for direction in markers:
		if tile_node.get_cell_source_id(1, direction.position):
			
		
			var highlight = highlight_scene.instantiate()
			add_child(highlight)
			highlight.position = get_node("EastMarker").position"""
	


func _on_dice_number_send_dice_number(number):
	print("sent number")
	dice_number += number


func check_surrond_tiles_existence():
	var tilemap_node = self.get_parent().get_node("TileMap")
	"""
	for direction in markers:
		print(tile_node.get_cell_source_id(1, direction.position))"""
	var surrounds = tilemap_node.get_surrounding_cells(self.position)
	print(surrounds)
	for tile in surrounds:
		print(tilemap_node.get_cell_source_id(5, tile))
