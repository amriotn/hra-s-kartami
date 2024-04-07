extends Resource
class_name CardEffect


const CARD_HAND_UI = preload("res://scenes/card_hand_ui/card_hand_ui.tscn")

const effect_functions = ["give_card"]

const TEST_CARD = "res://test_card.tres"

enum Target {SELF, SINLGE_ENEMY, ALL_ENEMIES, EVERYONE, AREA, ENVIRONMENT}

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
			print("give " + str(card_data.effect_data) + " card(s) to " + str(card_data.holder))
			for i in range(card_data.effect_data):
				var card = CARD_HAND_UI.instantiate()
				card.load_data(load(TEST_CARD), card_data.holder)
				card_data.holder.stats.hand.add_card(card)
				card_data.holder.stats.cards_in_hand.append(card)
