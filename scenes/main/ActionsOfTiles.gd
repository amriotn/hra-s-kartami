extends Node2D

var actions_array : Array
var move_player : Dictionary
var stuck_player : Dictionary
var tile_node : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	actions_array = self.get_children()
	tile_node = self.get_parent().get_node("TileMap")
	
	move_player = {}
	stuck_player = {}
	
	for action in actions_array:
		print("\t"+action.name)
		# = MovePlayer; StuckPlayer; GiveCard
		match action.name:
				"MovePlayer":
					for action_tile : Node2D in action.get_children():
						# = DivotvornyMec; ...
						print(action_tile.name)
						var actions_markers : Array = action_tile.get_children()
						# FIX MARKER POSITION TO CENTER OF TILE
						for marker : Marker2D in actions_markers:
							marker.global_position = tile_node.map_to_local(tile_node.local_to_map(marker.global_position))
						# move_player[start_marker] = destination_marker
						move_player[actions_markers[0].global_position] = actions_markers[1].global_position
				"StuckPlayer":
					for action_tile in action.get_children():
						var dice_number_needed = int(String(action_tile.name)[-1])
						var actions_markers : Array = action_tile.get_children()
						for marker : Marker2D in actions_markers:
							marker.global_position = tile_node.map_to_local(tile_node.local_to_map(marker.global_position))
							stuck_player[marker.global_position] = dice_number_needed
	
	print(move_player)
	print(stuck_player)
