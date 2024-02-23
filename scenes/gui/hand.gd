class_name Hand
extends Control

const SCREEN_EDGE_BORDER = 15.0 #percent
const CARD_SIZE = Vector2(133, 200)
const MAX_DISTANCE_BETWEEN_CARDS = 95.0 #percent

var hand_tween : Tween

func _ready() -> void:
	update_hand()
	#print("ready")
	for child in get_children():
		var card_hand_ui := child as CardHandUI
		card_hand_ui.reparent_requested.connect(_on_card_hand_ui_reparent_requested)
	


func _on_card_hand_ui_reparent_requested(child: CardHandUI) -> void:
	child.reparent(self)


func update_hand():
	var hand_list = get_children()
	var hand_size = hand_list.size()
	var viewport_size = get_viewport_rect().size
	
	#var horizontal_space = viewport_size.x - ((SCREEN_EDGE_BORDER/100 * viewport_size.x)*2)
	var horizontal_space = self.size.x
	var dist_between_cards = min(horizontal_space / hand_size, (MAX_DISTANCE_BETWEEN_CARDS/100*CARD_SIZE.x))
	var start_position = (horizontal_space/2)-(dist_between_cards*hand_size/2)
	
	#print(dist_between_cards)
	#print(start_position)
	
	for i in range(hand_size):
		#hand_list[i].position = Vector2(start_position, 0)
		hand_list[i].position = Vector2(start_position+dist_between_cards*i, 50)
		#print(hand_list[i].position)
		



func _on_mouse_exited():
	if hand_tween:
		hand_tween.kill()
	hand_tween = self.get_tree().create_tween()
	hand_tween.tween_property(self, "position:y", 950, 0.15)
