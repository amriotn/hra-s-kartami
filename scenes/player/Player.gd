extends Sprite2D

@onready var highlight_scene : PackedScene = preload("res://scenes/highlight/Highlight.tscn")
@onready var rolldice_button : Button = self.get_parent().get_node("MainCamera/GUI/CenterContainer/DiceControl/RollDice_button")

var tilemap_node : TileMap
var actions_of_tiles : Node2D

var dice_number : int = 0
var highlights : Array = []
var route_of_tiles : Array = []
# (4, 23) => tile_node.local_to_map(start_pos_marker.position)
var last_tile : Vector2i = Vector2i(29, 21)

var stuck_until_dice_number : int = 0

var stats : PlayerStats = null

func load_stats(player_stats : PlayerStats) -> void:
	stats = player_stats


func _on_dice_animated_sprite_send_dice_number(number):
	dice_number = number
	
	var tilemap_node : TileMap = self.get_parent().get_node("TileMap")
	
	var reference_tile = tilemap_node.local_to_map(self.position)
	
	if stuck_until_dice_number == 0 or dice_number == stuck_until_dice_number:
		check_surround_tiles_help(reference_tile, last_tile, dice_number)
		stuck_until_dice_number = 0
	

func check_surround_tiles_help(center_tile : Vector2i, previous_tile : Vector2i, dice_number : int):
	tilemap_node = self.get_parent().get_node("TileMap")
	actions_of_tiles = self.get_parent().get_node("ActionsOfTiles")
	
	
	route_of_tiles.append(center_tile)
	
	var current_surrounds : Array = tilemap_node.get_surrounding_cells(center_tile) # Získá souřadnice okolních polí
	#print("Tile ", center_tile, "surronds: ", current_surrounds,"\ndice:", dice_number)
	
	if dice_number > 0:
		if actions_of_tiles.crossroads.has(tilemap_node.map_to_local(center_tile)): # center_tile is a crossroad
			if dice_number == self.dice_number: # STRAIGHT WAY
				check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[2]), tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[2]), dice_number-1)
			elif self.dice_number%2 == 0: # EVEN WAY
				check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[1]), tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[1]), dice_number-1)
			else: # ODD WAY
				check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[0]), tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[0]), dice_number-1)
		else:
			for tile in current_surrounds:
				if tile != previous_tile and tile != last_tile:
					if tilemap_node.get_cell_source_id(0, tile) == 0: # = tile je na Layer 0 a je z TileSet 0
						check_surround_tiles_help(tile, center_tile, dice_number-1)
	elif dice_number <= 0:
		last_tile = previous_tile
		
		var highlight = highlight_scene.instantiate()
		tilemap_node.add_child(highlight)
		highlight.position = tilemap_node.map_to_local(center_tile)
		highlight.z_index = 5
		highlight.connect("send_highlight_position", Callable(self, "_on_highlight_send_highlight_position"))
		highlights.append(highlight)
		
func _on_highlight_send_highlight_position(highlight_position):
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", highlight_position, 0.1*dice_number)
	#self.position = highlight_position
	for highlight in highlights:
		highlight.queue_free()
	highlights.clear()
	
	tilemap_node = self.get_parent().get_node("TileMap")
	var tween = get_tree().create_tween()
	for tile in route_of_tiles:
		tween.tween_property(self, "position", tilemap_node.map_to_local(tile), 0.2)
		tween.tween_interval(0.2)
	
	
	rolldice_button.disabled = false
	
	print(route_of_tiles)
	route_of_tiles.clear()
	
	tween.connect("finished", handle_what_tile_player_stepped_on)
	
func handle_what_tile_player_stepped_on():
	tilemap_node = self.get_parent().get_node("TileMap")
	actions_of_tiles = self.get_parent().get_node("ActionsOfTiles")
	
	if actions_of_tiles.move_player.has(self.position):
		print("move player works")
		print(actions_of_tiles.move_player.get(self.position))
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", actions_of_tiles.move_player.get(self.position), 0.5)
		
	elif actions_of_tiles.stuck_player.has(self.position):
		print("stuck player works")
		print(actions_of_tiles.stuck_player.get(self.position))
		stuck_until_dice_number = actions_of_tiles.stuck_player.get(self.position)
	
	elif actions_of_tiles.crossroads.has(self.position):
		print("crossroads work")
		print(actions_of_tiles.crossroads.get(self.position))
	
	elif actions_of_tiles.give_card.has(self.position):
		print("give card works")
