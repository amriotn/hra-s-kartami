extends AnimatedSprite2D

signal send_dice_number(number)
@onready var roll_dice_button = $"../RollDice_button"

func _ready():
	add_user_signal("send_dice_number", [
		{"name":"dice_number", "type":TYPE_INT}
	])

func _on_roll_dice_button_pressed():
	
	var rng = RandomNumberGenerator.new()
	var dice_number = rng.randi_range(1, 6)
	
	roll_dice_button.disabled = true
	var dice_animations = self.sprite_frames.get_animation_names()
	
	self.play("roll")
	
	await self.animation_finished
	
	self.play(dice_animations[dice_number-1])
	
	emit_signal("send_dice_number", dice_number)
