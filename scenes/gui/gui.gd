extends CanvasLayer

@onready var roll_dice_button = $RollDice_button
@onready var end_turn_button = $EndTurnButton

@onready var collapsable_player_list = $CollapsablePlayerList
@onready var arrow_left : Sprite2D = $CollapsablePlayerList/CollapsePlayerListButton/ArrowLeft
@onready var player_list_v_box : VBoxContainer = $CollapsablePlayerList/PlayersScrollBar/PlayerListVBox
@onready var collapse_player_list_button : Button = $CollapsablePlayerList/CollapsePlayerListButton
@onready var players_scroll_bar : ScrollContainer = $CollapsablePlayerList/PlayersScrollBar
@onready var time_label = $TimeLabel
@onready var round_label = $RoundLabel
@onready var hand = $Hand

const PLAYER_DISPLAY_UI = preload("res://scenes/player_display_ui/player_display_ui.tscn")

var player_display_list : Array
var time = 0
var timer_on = false

func _process(delta):
	if timer_on:
		time += delta
	
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins, secs]
	time_label.text = time_passed

func _ready():
	if not Global.player_stats_resources.is_empty():
		for stat in Global.player_stats_resources:
			var player_display = PLAYER_DISPLAY_UI.instantiate()
			player_display.load_stats(stat)
			player_list_v_box.add_child(player_display)
			#print(stat.nickname, stat.points)
			player_display.player_icon.texture = load(stat.player_icon)
			player_display.player_icon.modulate = stat.player_color
			player_display.nickname.text = stat.nickname
			player_display.points.text = str(stat.points)
			stat.connect("stats_updated", Callable(player_display, "on_stats_updated"))
			player_display_list.append(player_display)
			

func _on_collapse_player_list_button_pressed():
	if arrow_left.flip_h == false: 
		#collapsable_player_list.position.x = -305.0
		arrow_left.flip_h = !arrow_left.flip_h
		var tween = get_tree().create_tween()
		tween.tween_property(collapsable_player_list, "position", Vector2(-305.0, collapsable_player_list.position.y), 0.25)
	else:
		#collapsable_player_list.position.x = 0.0
		arrow_left.flip_h = !arrow_left.flip_h
		var tween = get_tree().create_tween()
		tween.tween_property(collapsable_player_list, "position", Vector2(0.0, collapsable_player_list.position.y), 0.25)
		
"""
func _on_collapse_player_list_button_pressed():
	if players_scroll_bar.visible:
		players_scroll_bar.hide()
		collapse_player_list_button.position.x = 0.0
		arrow_left.flip_h = true
	else:
		players_scroll_bar.show()
		collapse_player_list_button.position.x = 305.0
		arrow_left.flip_h = false
"""

func _on_pause_button_pressed():
	pass # Replace with function body.


