class_name CardHandUI
extends Control

signal reparent_requested(which_card_ui: CardHandUI)

@onready var shine = $Shine
@onready var color_rect: ColorRect = $DebugColor
@onready var state: Label = $State
@onready var drop_detection_area = $DropDetectionArea
@onready var card_state_machine : CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []

func _ready() -> void:
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_drop_detection_area_area_entered(area):
	if not targets.has(area):
		targets.append(area)


func _on_drop_detection_area_area_exited(area):
	targets.erase(area)
