extends Label


func _on_roll_dice_button_pressed():
	var rng = RandomNumberGenerator.new()
	var dice_numer = rng.randi_range(1, 6)
	text = str(dice_numer)
