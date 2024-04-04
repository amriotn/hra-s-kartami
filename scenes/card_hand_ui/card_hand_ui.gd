class_name CardHandUI
extends Control

signal reparent_requested(which_card_ui: CardHandUI)

@onready var shine = $Shine
@onready var color_rect: ColorRect = $DebugColor
@onready var state: Label = $State
@onready var drop_detection_area = $DropDetectionArea
@onready var card_state_machine : CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []


var data : CardResource = null

func load_data(card_data : CardResource) -> void:
	data = card_data


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
	var card_detection_zones_layer : Area2D = get_tree().get_first_node_in_group("card_detection_zones")
	if area == card_detection_zones_layer:
		if not targets.has(area):
			targets.append(area)
			print(str(area) + "added")


func _on_drop_detection_area_area_exited(area):
	var card_detection_zones_layer : Area2D = get_tree().get_first_node_in_group("card_detection_zones")
	if area == card_detection_zones_layer:
		targets.erase(area)
		print(str(area) + "removed")
