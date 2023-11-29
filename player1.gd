extends Sprite2D

#var tile_node = self.get_parent().get_node("TileMap")
#var first_tile_pos = tile_node.get_used_cells(0)[0]

func _ready():
	var tile_node = self.get_parent().get_node("TileMap")
	var first_tile_pos = tile_node.get_used_cells(0)[0]
	position = tile_node.map_to_local(first_tile_pos)
	print(position)
