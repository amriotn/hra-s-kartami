extends Label
signal send_dice_number(number)



func _ready():
	add_user_signal("send_dice_number", [
		{"name":"dice_number", "type":TYPE_INT}
	])

func _on_roll_dice_button_pressed():
	#func roll_dice():
	var rng = RandomNumberGenerator.new()
	var dice_number = rng.randi_range(1, 6)
	text = str(dice_number)
	print("emitting signal")
	
	emit_signal("send_dice_number", dice_number)
