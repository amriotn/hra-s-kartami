extends Resource
class_name CardEffect


const CARD_HAND_UI = preload("res://scenes/card_hand_ui/card_hand_ui.tscn")

const effect_functions = ["give_card", "give_immunity", "move_player_to_player", "stuck_player", "swap_positions"]

const CARDS = ["res://cards/everyone_2_stuck.tres", "res://cards/everyone_swap_pos.tres", "res://cards/give_3_cards.tres", "res://cards/give_3_immunity.tres", "res://cards/move_enemy_to_self.tres", "res://cards/move_to_random_player.tres", "res://cards/stuck_2_player.tres"]

enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE, AREA, ENVIRONMENT}

var card_data : CardResource

func create_instance(data : CardResource):
	var instance : CardEffect = CardEffect.new()
	return instance

func trigger_effect(usable_card_data : CardResource):
	card_data = usable_card_data
	call(effect_functions[card_data.effect])

func give_card():
	#print("give " + str(card_data.effect_data) + " card(s) to " + str(card_data.effect_target))
	match card_data.effect_target:
		Target.SELF:
			#print("give " + str(card_data.effect_data) + " card(s) to " + str(card_data.holder))
			for i in range(card_data.effect_data):
				var card = CARD_HAND_UI.instantiate()
				var rng = RandomNumberGenerator.new()
				var random_card = rng.randi_range(0, CARDS.size()-1)
				card.load_data(load(CARDS[random_card]), card_data.holder)
				card_data.holder.stats.hand.add_card(card)

func give_immunity():
	match card_data.effect_target:
		Target.SELF:
			print("give immunity to "+str(card_data.holder)+" for "+str(card_data.effect_data)+" rounds")
			card_data.holder.stats.active_effect = card_data.holder.stats.Effect.IMMUNE
			card_data.holder.stats.effect_active_for_rounds = card_data.effect_data

func move_player_to_player():
	match card_data.effect_target:
		Target.SELF:
			# to random enemy
			var rng = RandomNumberGenerator.new()
			var roll_random = rng.randi_range(0, Global.player_list.size()-1)
			while Global.player_list[roll_random] == card_data.holder:
				roll_random = rng.randi_range(0, Global.player_list.size()-1)
			print("jump to " + str(Global.player_list[roll_random]))
			card_data.holder.global_position = Vector2(Global.player_list[roll_random].global_position)
			card_data.holder.last_tile = Vector2i(Global.player_list[roll_random].last_tile)
			
			
		Target.SINGLE_ENEMY:
			for player in Global.player_list:
				if player != card_data.holder:
					player.click_detection.show()
			card_data.holder.choose_player.show()
			await card_data.holder.confirm_action_button.pressed
			print("move "+str(Global.card_player_target)+" to "+str(card_data.holder))
			
			Global.card_player_target.global_position = Vector2(card_data.holder.global_position)
			Global.card_player_target.last_tile = Vector2i(card_data.holder.last_tile)
			Global.card_player_target = null
			
			for player in Global.player_list:
				player.click_detection.hide()
				player.select.hide()
			card_data.holder.choose_player.hide()
			
func stuck_player():
	match card_data.effect_target:
		Target.SELF:
			print("give stuck to "+str(card_data.holder)+" for "+str(card_data.effect_data)+" rounds")
			card_data.holder.stats.active_effect = card_data.holder.stats.Effect.STUCK
			card_data.holder.stats.effect_active_for_rounds = card_data.effect_data
		
		Target.SINGLE_ENEMY:
			for player in Global.player_list:
				if player != card_data.holder:
					player.click_detection.show()
			card_data.holder.choose_player.show()
			await card_data.holder.confirm_action_button.pressed
			
			print("give stuck to "+str(Global.card_player_target)+" for "+str(card_data.effect_data)+" rounds")
			Global.card_player_target.stats.active_effect = card_data.holder.stats.Effect.STUCK
			Global.card_player_target.stats.effect_active_for_rounds = card_data.effect_data
			
			
			Global.card_player_target = null
			for player in Global.player_list:
				player.click_detection.hide()
				player.select.hide()
			card_data.holder.choose_player.hide()
		
		Target.EVERYONE:
			for player in Global.player_list:
				print("give stuck to "+str(player)+" for "+str(card_data.effect_data)+" rounds")
				player.stats.active_effect = card_data.holder.stats.Effect.STUCK
				player.stats.effect_active_for_rounds = card_data.effect_data

func swap_positions():
	match card_data.effect_target:
		Target.SELF:
			# náhodné políčko na mapě
			print("give stuck to "+str(card_data.holder)+" for "+str(card_data.effect_data)+" rounds")
			card_data.holder.stats.active_effect = card_data.holder.stats.Effect.STUCK
			card_data.holder.stats.effect_active_for_rounds = card_data.effect_data
		
		Target.SINGLE_ENEMY:
			for player in Global.player_list:
				if player != card_data.holder:
					player.click_detection.show()
			card_data.holder.choose_player.show()
			await card_data.holder.confirm_action_button.pressed
			
			print("swap positions with "+str(Global.card_player_target))
			var previous_position = Vector2(card_data.holder.global_position)
			var previous_last_tile = Vector2i(card_data.holder.last_tile)
			card_data.holder.global_position = Vector2(Global.card_player_target.global_position)
			card_data.holder.last_tile = Vector2i(Global.card_player_target.last_tile)
			Global.card_player_target.global_position = previous_position
			Global.card_player_target.last_tile = previous_last_tile
			
			
			Global.card_player_target = null
			for player in Global.player_list:
				player.click_detection.hide()
				player.select.hide()
			card_data.holder.choose_player.hide()
		
		Target.EVERYONE:
			print("everyone swap positions")
			var rng = RandomNumberGenerator.new()
			for player in Global.player_list:
				var roll_random = rng.randi_range(0, Global.player_list.size()-1)
				while Global.player_list[roll_random] == player:
					roll_random = rng.randi_range(0, Global.player_list.size()-1)
				print("swap positions with " + str(Global.player_list[roll_random]))
				
				var previous_position = Vector2(player.global_position)
				var previous_last_tile = Vector2i(player.last_tile)
				player.global_position = Vector2(Global.player_list[roll_random].global_position)
				player.last_tile = Vector2i(Global.player_list[roll_random].last_tile)
				Global.player_list[roll_random].global_position = previous_position
				Global.player_list[roll_random].last_tile = previous_last_tile
