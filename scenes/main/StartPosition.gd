extends Marker2D



func _ready():
	var tile_node = self.get_parent().get_node("TileMap")
	# sets position of StartPosition marker to the center of the desired starting tile
	position = tile_node.map_to_local(tile_node.local_to_map(self.position))
