class_name Hand
extends HBoxContainer


func _ready() -> void:
	for child in get_children():
		var card_hand_ui := child as CardHandUI
		card_hand_ui.reparent_requested.connect(_on_card_hand_ui_reparent_requested)


func _on_card_hand_ui_reparent_requested(child: CardHandUI) -> void:
	child.reparent(self)
