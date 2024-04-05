class_name Hand
extends Control

const SCREEN_EDGE_BORDER = 15.0 #percent
const CARD_SIZE = Vector2(133, 200)
const MAX_DISTANCE_BETWEEN_CARDS = 95.0 #percent

var hand : Array
var hand_tween : Tween

func _ready() -> void:
	update_hand()
	#print("ready")

func load_hand(cards_array : Array): # player_stats.cards_in_hand
	hand = cards_array
	for card in hand:
		self.add_child(card)
		var card_hand_ui := card as CardHandUI
		card_hand_ui.reparent_requested.connect(_on_card_hand_ui_reparent_requested)
	update_hand()


func _on_card_hand_ui_reparent_requested(child: CardHandUI) -> void:
	child.reparent(self)

func add_card(card : CardHandUI):
	hand.append(card)
	add_child(card)
	var card_hand_ui := card as CardHandUI
	card_hand_ui.reparent_requested.connect(_on_card_hand_ui_reparent_requested)
	update_hand()

func update_hand():
	var hand_list = get_children()
	var hand_size = hand_list.size()
	var viewport_size = get_viewport_rect().size
	
	#var horizontal_space = viewport_size.x - ((SCREEN_EDGE_BORDER/100 * viewport_size.x)*2)
	var horizontal_space = self.size.x
	
	#print(dist_between_cards)
	#print(start_position)
	var dist_between_cards = min(horizontal_space / hand_size, (MAX_DISTANCE_BETWEEN_CARDS/100*CARD_SIZE.x))
	var start_position = (horizontal_space/2)-(dist_between_cards*hand_size/2)
	
	for i in range(hand_size):
		#hand_list[i].position = Vector2(start_position, 0)
		hand_list[i].position = Vector2(start_position+dist_between_cards*i, 50)
		#print(hand_list[i].position)
		

func clear_hand():
	for child in get_children():
		child.hide()

func _on_mouse_exited():
	if hand_tween:
		hand_tween.kill()
	hand_tween = self.get_tree().create_tween()
	hand_tween.tween_property(self, "position:y", 950, 0.15)
