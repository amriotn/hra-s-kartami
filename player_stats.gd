extends Resource
class_name PlayerStats

@export var nickname : String
@export var player_color : Color
@export var points : int = 0

func _init(p_nickname = "", p_color = Color.WHITE):
	nickname = p_nickname
	player_color = p_color
