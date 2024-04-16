extends Resource
class_name PlayerStats

const HAND = preload("res://hand.tscn")

@export var nickname : String
@export var player_color : Color
var player_icon : String
var player_character : String

@export var points : int = 0
var leaderboard_position : int

enum Effect {NONE, STUCK, LUCK, SPEED, IMMUNE}

var active_effect : Effect
var effect_active_for_rounds : int

var hand : Hand

signal stats_updated

func _init(p_nickname = "", p_color = Color.WHITE, p_icon_index = 0):
	nickname = p_nickname
	player_color = p_color
	player_icon = Global.icons[p_icon_index]
	player_character = Global.characters[p_icon_index]
	
	active_effect = Effect.NONE
	hand = HAND.instantiate()
	

func create_instance():
	var instance : PlayerStats = self.duplicate()
	instance.nickname = nickname
	instance.player_color = player_color
	instance.points = points
	instance.leaderboard_position = leaderboard_position
	instance.effect_active_for_rounds = effect_active_for_rounds
	instance.active_effect = active_effect
	instance.hand = hand
	
	return instance


