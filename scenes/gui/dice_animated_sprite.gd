extends AnimatedSprite2D

signal send_dice_number(number)
#@onready var roll_dice_button = $"../RollDice_button"
@onready var roll_dice_button = get_tree().get_nodes_in_group("ui_layer")[0].roll_dice_button
@onready var area_2d : Area2D = $Area2D
@onready var fade_out : Sprite2D = $"../FadeOut"
@onready var audio_stream_player_dice = $AudioStreamPlayerDice
@onready var player_parent = $".."

func _ready():
	roll_dice_button.pressed.connect(_on_roll_dice_button_pressed)
	add_user_signal("send_dice_number", [
		{"name":"dice_number", "type":TYPE_INT}
	])


func _on_roll_dice_button_pressed():
	area_2d.hide()
	fade_out.hide()
	player_parent.stats.hand.hide()
	
	var rng = RandomNumberGenerator.new()
	var dice_number = rng.randi_range(1, 6)
	
	roll_dice_button.disabled = true
	var dice_animations = self.sprite_frames.get_animation_names()
	
	self.play("roll")
	audio_stream_player_dice.play()
	
	await self.animation_finished
	
	self.play(dice_animations[dice_number-1])
	
	
	emit_signal("send_dice_number", dice_number)


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_roll_dice_button_pressed()


func _on_visibility_changed():
	if visible:
		if area_2d and fade_out:
			area_2d.show()
			fade_out.show()
	else:
		if area_2d and fade_out:
			area_2d.hide()
			fade_out.hide()
