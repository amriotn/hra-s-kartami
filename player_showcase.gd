extends Control

@onready var player_order : Label = $Order
@onready var nickname : LineEdit = $PlayerName
@onready var color : ColorPickerButton = $Color
@onready var warning_label = $WarningLabel

@onready var delete_button = $DeleteButton
@onready var x_label = $XLabel


func _to_string():
	return str(player_order.text) +"; "+ str(nickname.text) +"; "+ str(color.color)


func _on_player_name_text_changed(new_text):
	if nickname.text == "":
		warning_label.show()
	else:
		warning_label.hide()


