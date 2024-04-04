extends Resource
class_name PlayerStats

@export var nickname : String
@export var player_color : Color

@export var points : int = 0
var leaderborad_position : int
var stuck_immunity : int = 0

enum Effect {NONE, STUCK, LUCK, SPEED, IMMUNE}

@export var card_in_hand : Array = []

func _init(p_nickname = "", p_color = Color.WHITE):
	nickname = p_nickname
	player_color = p_color
