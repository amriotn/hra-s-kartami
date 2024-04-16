extends Control

@onready var player_order : Label = $Order
@onready var nickname : LineEdit = $PlayerName
@onready var color : ColorPickerButton = $Color
@onready var warning_label = $WarningLabel

@onready var delete_button = $DeleteButton
@onready var x_label = $XLabel

@onready var icon : Sprite2D = $Icon
var player_icon_index : int = 0

func _to_string():
	return str(player_order.text) +"; "+ str(nickname.text) +"; "+ str(color.color)


func _on_player_name_text_changed(new_text):
	if nickname.text == "":
		warning_label.show()
	else:
		warning_label.hide()




func _on_choose_icon_left_pressed():
	player_icon_index -= 1
	if player_icon_index < 0:
		player_icon_index = Global.icons.size()-1
	icon.texture = load(Global.icons[player_icon_index])


func _on_choose_icon_right_pressed():
	player_icon_index += 1
	if player_icon_index > Global.icons.size()-1:
		player_icon_index = 0
	icon.texture = load(Global.icons[player_icon_index])


func _on_color_color_changed(color):
	icon.self_modulate = color
