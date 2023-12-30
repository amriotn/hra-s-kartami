extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_node = self.get_parent().get_node("TileMap")
	position = tile_node.map_to_local(tile_node.local_to_map(self.position))
	#print(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



