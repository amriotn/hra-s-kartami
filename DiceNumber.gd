extends Label
signal send_dice_number(number)

func _on_roll_dice_button_pressed():
	var rng = RandomNumberGenerator.new()
	var dice_number = rng.randi_range(1, 6)
	text = str(dice_number)
	emit_signal("send_dice_number", dice_number)
