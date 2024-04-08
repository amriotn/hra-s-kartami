extends Node2D

var tile_node : TileMap
var actions_array : Array
var move_player : Dictionary
var stuck_player : Dictionary
var crossroads : Dictionary
var give_card : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	actions_array = self.get_children()
	tile_node = self.get_parent().get_node("TileMap")
	
	move_player = {}
	stuck_player = {}
	
	for action in actions_array:
#		print(action.name)
		# = MovePlayer; StuckPlayer; GiveCard
		match action.name:
				"MovePlayer":
					for action_tile : Node2D in action.get_children():
						# = DivotvornyMec; ...
#						print("\t"+action_tile.name)
						var actions_markers : Array = action_tile.get_children()
						# FIX MARKER POSITION TO CENTER OF TILE
						for marker : Marker2D in actions_markers:
							marker.global_position = tile_node.map_to_local(tile_node.local_to_map(marker.global_position))
						# move_player[start_marker] = [destination_marker, invalid_way_marker]
						move_player[actions_markers[0].global_position] = [actions_markers[1].global_position, actions_markers[2].global_position]
				"StuckPlayer":
					for action_tile in action.get_children():
						# = San_Roll3, ...
#						print("\t"+action_tile.name)
						var dice_number_needed = int(String(action_tile.name)[-1])
						var actions_markers : Array = action_tile.get_children() # All tiles player can be stuck on
						for marker : Marker2D in actions_markers:
							# fix marker positon to center of tile
							marker.global_position = tile_node.map_to_local(tile_node.local_to_map(marker.global_position))
							# on this tile, player will be stuck until he throws => dice_number_needed
							stuck_player[marker.global_position] = dice_number_needed
				"Crossroads":
					for action_tile in action.get_children():
						# Jezibaba, ...
#						print("\t"+action_tile.name)
						var actions_markers : Array = action_tile.get_children() # StartMarker, OddWay, EvenWay
						
						# fix marker positon to center of tile
						for marker : Marker2D in actions_markers:
							marker.global_position = tile_node.map_to_local(tile_node.local_to_map(marker.global_position))
						
						# crossroads = { (StartMarker) : ([OddWay, EvenWay, StraightWay]) }
						if actions_markers.size() == 4:
							crossroads[actions_markers[0].global_position] = [actions_markers[1].global_position, actions_markers[2].global_position, actions_markers[3].global_position]
				"GiveCard":
					for card_marker : Marker2D in action.get_children():
						card_marker.global_position = tile_node.map_to_local(tile_node.local_to_map(card_marker.global_position))
						
						var card_name : String = card_marker.name
						var last_index : int = card_name.length()-1
						while card_name[last_index].is_valid_int():
							last_index -= 1
						card_name = card_name.substr(0, last_index+1)
						var resource_path = "res://"+str(card_name)+".tres"
						give_card[card_marker.global_position] = resource_path
#	print(move_player)
#	print(stuck_player)
#	print(crossroads)
