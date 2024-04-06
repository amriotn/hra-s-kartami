extends Resource
class_name CardEffect

const effect_functions = ["give_card"]

var effect : int
var effect_data : int
var effect_target : int
var effect_target_data : int

var card_data : CardResource

func trigger_effect():
	call(effect_functions[effect])

func give_card():
	print("give " + str(card_data.effect_data) + " card(s) to " + str(card_data.effect_target))
