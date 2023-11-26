extends Sprite2D

var current_tile
var current_route

func _ready():
	current_route = get_parent().get_node("Route1")
	current_tile = current_route.child_tiles[0]
	#self.position = get_parent().get_node("Route1").position
	self.position = current_tile.position
	print(self.position)
	print(current_tile)



func _on_roll_dice_button_pressed():
	var tile_index = current_route.child_tiles.find(current_tile)
	var move_by = int(get_parent().get_node("DiceNumber").text)
	if (tile_index + move_by <= current_route.child_tiles.size()):
		current_tile = current_route.child_tiles[tile_index+move_by]
	else:
		current_tile = current_route.child_tiles[current_route.child_tiles.size()-1]
	self.position = current_tile.position
	
