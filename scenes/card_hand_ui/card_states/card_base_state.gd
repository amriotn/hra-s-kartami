extends CardState


func enter() -> void:
	if not card_hand_ui.is_node_ready():
		await card_hand_ui.ready
	
	card_hand_ui.reparent_requested.emit(card_hand_ui)
	card_hand_ui.color_rect.color = Color.WEB_GREEN
	card_hand_ui.state.text = "BASE"
	card_hand_ui.pivot_offset = Vector2.ZERO

"""
func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		#card_hand_ui.pivot_offset = card_hand_ui.get_global_mouse_position() - card_hand_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
"""

func on_mouse_entered() -> void:
	card_hand_ui.state.text = "HOVER"

func on_mouse_exited() -> void:
	card_hand_ui.state.text = "BASE"



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

