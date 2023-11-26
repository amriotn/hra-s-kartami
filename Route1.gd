extends Sprite2D

var child_tiles = []

func _ready():
	child_tiles = get_children()
	child_tiles.insert(0, self)
	#print(child_tiles)
	
