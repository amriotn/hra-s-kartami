extends Sprite2D
class_name Player

@onready var highlight_scene : PackedScene = preload("res://scenes/highlight/Highlight.tscn")
#@onready var rolldice_button : Button = self.get_parent().get_node("MainCamera/GUI/CenterContainer/DiceControl/RollDice_button")
@onready var roll_dice_button = get_tree().get_nodes_in_group("ui_layer")[0].roll_dice_button
@onready var end_turn_button = get_tree().get_nodes_in_group("ui_layer")[0].end_turn_button
@onready var dice_animated_sprite = $DiceAnimatedSprite
@onready var player_finder = $PlayerFinder
@onready var audio_stream_player_player : AudioStreamPlayer = $AudioStreamPlayerPlayer

var tilemap_node : TileMap
var actions_of_tiles : ActionsOfTiles

const DEFAULT_OFFSET : Vector2 = Vector2(0, -125)
const CARD_HAND_UI = preload("res://scenes/card_hand_ui/card_hand_ui.tscn")

var dice_number : int = 0
var highlights : Array = []
var route_of_tiles : Array = []
# (4, 23) => tile_node.local_to_map(start_pos_marker.position)
var last_tile : Vector2i = Vector2i(29, 21)

var stuck_until_dice_number : int = 0
var ventured_tiles : Array = []

var swamp_route_swap : bool = false
var standing_on_zabi_kral : bool = false
var carodej_number : int = 1

var stats : PlayerStats = null

func load_stats(player_stats : PlayerStats) -> void:
	stats = player_stats.create_instance()


func _on_dice_animated_sprite_send_dice_number(number):
	dice_number = number
	route_of_tiles.clear()
	
	var tilemap_node : TileMap = self.get_parent().get_node("TileMap")
	
	var reference_tile = tilemap_node.local_to_map(self.position)
	
	stats.effect_active_for_rounds -= 1
	if stats.effect_active_for_rounds <= 0:
		stats.active_effect == stats.Effect.NONE
		stats.effect_active_for_rounds = 0
			
	
	if ((stuck_until_dice_number == 0 or dice_number == stuck_until_dice_number) and standing_on_zabi_kral == false) or stats.active_effect == stats.Effect.IMMUNE:
		if dice_number == stuck_until_dice_number:
			match stuck_until_dice_number:
				3:
					stats.active_effect = stats.Effect.IMMUNE
					stats.effect_active_for_rounds = 2
				1:
					stats.active_effect = stats.Effect.IMMUNE
					stats.effect_active_for_rounds = 1
		route_of_tiles.clear()
		self.position = tilemap_node.map_to_local(tilemap_node.local_to_map(self.position))
		check_surround_tiles_help(reference_tile, last_tile, dice_number)
		stuck_until_dice_number = 0
		
	elif standing_on_zabi_kral == true:
		if dice_number == 1:
			if swamp_route_swap:
			# poslat na políčko korunky
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", actions_of_tiles.korunka.global_position, 0.5)
				ventured_tiles.clear()
				standing_on_zabi_kral = false
			else:
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", actions_of_tiles.tun.global_position, 0.5)
				ventured_tiles.clear()
				standing_on_zabi_kral = false
		else:
			# aktivovat správný conditional_jump
			if swamp_route_swap == false:
				actions_of_tiles.swamp[actions_of_tiles.conditional_jump_there.get_children()[0].global_position] = [actions_of_tiles.conditional_jump_there.get_children()[1].global_position]
				standing_on_zabi_kral = false
				route_of_tiles.clear()
				self.position = tilemap_node.map_to_local(tilemap_node.local_to_map(self.position))
				check_surround_tiles_help(reference_tile, last_tile, dice_number)
				actions_of_tiles.swamp.erase(actions_of_tiles.conditional_jump_there.get_children()[0].global_position)
			else:
				actions_of_tiles.swamp[actions_of_tiles.conditional_jump_back.get_children()[0].global_position] = [actions_of_tiles.conditional_jump_back.get_children()[1].global_position]
				standing_on_zabi_kral = false
				route_of_tiles.clear()
				self.position = tilemap_node.map_to_local(tilemap_node.local_to_map(self.position))
				check_surround_tiles_help(reference_tile, last_tile, dice_number)
				actions_of_tiles.swamp.erase(actions_of_tiles.conditional_jump_back.get_children()[0].global_position)
	
	end_turn_button.disabled = false

func check_surround_tiles_help(center_tile : Vector2i, previous_tile : Vector2i, dice_number : int):
	tilemap_node = self.get_parent().get_node("TileMap")
	actions_of_tiles = self.get_parent().get_node("ActionsOfTiles")
	
	
	route_of_tiles.append(center_tile)
	
	var current_surrounds : Array = tilemap_node.get_surrounding_cells(center_tile) # Získá souřadnice okolních polí
	#print("Tile ", center_tile, "surronds: ", current_surrounds,"\ndice:", dice_number)
	
	if dice_number > 0:
		if actions_of_tiles.crossroads.has(tilemap_node.map_to_local(center_tile)): # center_tile is a crossroad
			if actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile)).size() == 3:
				ventured_tiles.clear()
				if dice_number == self.dice_number: # STRAIGHT WAY
					check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[2]), tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[2]), dice_number-1)
				elif self.dice_number%2 == 0: # EVEN WAY
					check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[1]), tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[1]), dice_number-1)
				else: # ODD WAY
					check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[0]), tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[0]), dice_number-1)
			elif actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile)).size() == 1:
				check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[0]), tilemap_node.local_to_map(actions_of_tiles.crossroads.get(tilemap_node.map_to_local(center_tile))[0]), dice_number-1)
		elif actions_of_tiles.swamp.has(tilemap_node.map_to_local(center_tile)) and actions_of_tiles.swamp.get(tilemap_node.map_to_local(center_tile)).size() == 1 and actions_of_tiles.swamp.get(tilemap_node.map_to_local(center_tile))[0] is Vector2:
				check_surround_tiles_help(tilemap_node.local_to_map(actions_of_tiles.swamp.get(tilemap_node.map_to_local(center_tile))[0]), tilemap_node.local_to_map(actions_of_tiles.swamp.get(tilemap_node.map_to_local(center_tile))[0]), dice_number-1)
		elif actions_of_tiles.specials.has(tilemap_node.map_to_local(center_tile)) and ((actions_of_tiles.specials.get(tilemap_node.map_to_local(center_tile)).name == "PrasataExit1" and carodej_number == 1) or (actions_of_tiles.specials.get(tilemap_node.map_to_local(center_tile)).name == "PrasataExit2" and carodej_number == 2)):
			var child_markers = actions_of_tiles.specials.get(tilemap_node.map_to_local(center_tile)).get_children()
			var destination_pos = child_markers[1].global_position
			var invalid_way_pos = child_markers[2].global_position
			check_surround_tiles_help(tilemap_node.local_to_map(destination_pos), tilemap_node.local_to_map(invalid_way_pos), dice_number-1)
		
		else:
			for tile in current_surrounds:
				if tile != previous_tile and tile != last_tile and tile: #  not in ventured_tiles
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
		ventured_tiles.append(tile)
		tween.tween_property(self, "position", tilemap_node.map_to_local(tile), 0.2)
		tween.tween_interval(0.2)
	
	
	
	
	#rolldice_button.disabled = false
	
	#print(route_of_tiles)
	route_of_tiles.clear()
	
	tween.connect("finished", handle_what_tile_player_stepped_on)
	
func handle_what_tile_player_stepped_on():
	tilemap_node = self.get_parent().get_node("TileMap")
	actions_of_tiles = self.get_parent().get_node("ActionsOfTiles")
	
	stuck_until_dice_number = 0
	
	if actions_of_tiles.move_player.has(self.position):
		print("move player works")
		print(actions_of_tiles.move_player.get(self.position))
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", actions_of_tiles.move_player.get(self.position)[0], 0.5)
		ventured_tiles.clear()
		ventured_tiles.append(tilemap_node.local_to_map(actions_of_tiles.move_player.get(self.position)[1]))
		last_tile = ventured_tiles[0]
		
	elif actions_of_tiles.stuck_player.has(self.position):
		print("stuck player works")
		print(actions_of_tiles.stuck_player.get(self.position))
		stuck_until_dice_number = actions_of_tiles.stuck_player.get(self.position)
	
	elif actions_of_tiles.crossroads.has(self.position):
		print("crossroads work")
		print(actions_of_tiles.crossroads.get(self.position))
	
	elif actions_of_tiles.give_card.has(self.position):
		print("give card works")
		print(actions_of_tiles.give_card.get(self.position))
		var card_data_path = actions_of_tiles.give_card.get(self.position)
		var card = CARD_HAND_UI.instantiate()
		var card_data : CardResource = load(card_data_path)
		#card_data.holder = self
		card.load_data(card_data, self)
		#card.data.holder = self
		#print(str(card.data.holder)+ " PLAYER")
		stats.hand.add_card(card)
	
	elif actions_of_tiles.swamp.has(self.position):
		print(actions_of_tiles.swamp.get(self.position))
		if actions_of_tiles.swamp.get(self.position).size() == 2:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", actions_of_tiles.swamp.get(self.position)[0], 0.5)
			ventured_tiles.clear()
			ventured_tiles.append(tilemap_node.local_to_map(actions_of_tiles.swamp.get(self.position)[1]))
			last_tile = ventured_tiles[0]
			
			
		elif actions_of_tiles.swamp.get(self.position).size() == 1 and actions_of_tiles.swamp.get(self.position)[0] is int:
			stuck_until_dice_number = actions_of_tiles.swamp.get(self.position)[0]
			stats.active_effect = stats.Effect.STUCK
	
	if actions_of_tiles.specials.has(self.position):
		print(actions_of_tiles.specials.get(self.position))
		var action = actions_of_tiles.specials.get(self.position)
		var action_name : String = action.name
		var last_index : int = action_name.length()-1
		while action_name[last_index].is_valid_int():
			last_index -= 1
		action_name = action_name.substr(0, last_index+1)
		match action_name:
			"PtakOhnivak":
				var child_markers = action.get_children()
				if swamp_route_swap == false:
					var destination_pos = child_markers[2].global_position
					var invalid_way_pos = child_markers[3].global_position
					var tween = get_tree().create_tween()
					tween.tween_property(self, "position", destination_pos, 0.5)
					ventured_tiles.clear()
					ventured_tiles.append(tilemap_node.local_to_map(invalid_way_pos))
					last_tile = ventured_tiles[0]
					await get_tree().create_timer(0.6).timeout
					handle_what_tile_player_stepped_on()
				else:
					var destination_pos = child_markers[4].global_position
					var tween = get_tree().create_tween()
					tween.tween_property(self, "position", destination_pos, 0.5)
					ventured_tiles.clear()
			"Jablicko":
				var child_markers = action.get_children()
				var destination_pos
				var invalid_way_pos
				destination_pos = child_markers[1].global_position
				if swamp_route_swap == false:
					invalid_way_pos = child_markers[2].global_position
				else:
					invalid_way_pos = child_markers[3].global_position
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", destination_pos, 0.5)
				ventured_tiles.clear()
				ventured_tiles.append(tilemap_node.local_to_map(invalid_way_pos))
				last_tile = ventured_tiles[0]
			"ZabiKral":
				standing_on_zabi_kral = true
			"Tun":
				swamp_route_swap = true
				ventured_tiles.clear()
			
			"Obr":
				var child_markers = action.get_children()
				var destination_pos = child_markers[4].global_position
				var invalid_way_pos = child_markers[5].global_position
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", destination_pos, 0.5)
				ventured_tiles.clear()
				ventured_tiles.append(tilemap_node.local_to_map(invalid_way_pos))
				last_tile = ventured_tiles[0]
			
			"Carodej":
				print(action.name.substr(last_index+1, action.name.length()-1))
				
				carodej_number = int(action.name.substr(last_index+1, action.name.length()-1))
				
				var child_markers = action.get_children()
				var destination_pos = child_markers[1].global_position
				var invalid_way_pos = child_markers[2].global_position
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", destination_pos, 0.5)
				ventured_tiles.clear()
				ventured_tiles.append(tilemap_node.local_to_map(invalid_way_pos))
				last_tile = ventured_tiles[0]
				
			"Goals":
				print("player erase")
				stats.has_finished = true
			
@onready var choose_player = $ChoosePlayer
@onready var click_detection = $ClickDetection
@onready var confirm_action_button : Button = $ChoosePlayer/ConfirmActionButton
@onready var select = $Select


func _on_click_detection_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Global.card_player_target != null:
			Global.card_player_target.select.hide()
		
		Global.card_player_target = self
		select.show()
		
		for player in Global.player_list:
			if player.choose_player.visible == true:
				player.confirm_action_button.disabled = false
