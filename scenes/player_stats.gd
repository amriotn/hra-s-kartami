extends Resource
class_name PlayerStats

const HAND = preload("res://hand.tscn")

@export var nickname : String
@export var player_color : Color

@export var points : int = 0
var leaderborad_position : int
var stuck_immunity : int = 0

enum Effect {NONE, STUCK, LUCK, SPEED, IMMUNE}

var active_effect : Effect
@export var cards_in_hand : Array = []
var hand : Hand

func _init(p_nickname = "", p_color = Color.WHITE):
	nickname = p_nickname
	player_color = p_color
	active_effect = Effect.NONE
	hand = HAND.instantiate()

func create_instance():
	var instance : PlayerStats = self.duplicate()
	instance.nickname = nickname
	instance.player_color = player_color
	instance.points = points
	instance.leaderborad_position = leaderborad_position
	instance.stuck_immunity = stuck_immunity
	instance.active_effect = active_effect
	instance.cards_in_hand = cards_in_hand
	instance.hand = hand
	
	return instance
