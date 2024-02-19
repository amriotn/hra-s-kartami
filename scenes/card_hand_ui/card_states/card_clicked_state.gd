extends CardState


func enter() -> void:
	card_hand_ui.color_rect.color = Color.ORANGE
	card_hand_ui.state.text = "CLICKED"
	#card_hand_ui.drop_detection_area.monitoring = true
	
"""
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	#if event is InputEventMouseMotion:
		#transition_requested.emit(self, CardState.State.DRAGGING)
"""

var threshold_time = 0.2
var timer = 0
var action_started = false

func _physics_process(delta):
	if Input.is_action_just_pressed("left_mouse"):
		action_started = true
		
	if Input.is_action_pressed("left_mouse") and action_started:
		timer += delta
		
	if timer >= threshold_time and action_started:
		action_started = false
		timer = 0
		print("hold")
		transition_requested.emit(self, CardState.State.DRAGGING)

	if Input.is_action_just_released("left_mouse"):
		if timer < threshold_time and action_started:
			print("press")
		action_started = false
		timer = 0

