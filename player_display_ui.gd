extends Control

@onready var select_gradient = $SelectGradient

@onready var player_icon : Sprite2D = $PlayerIcon
@onready var leaderboard_position : Label = $Position
@onready var nickname : Label = $Nickname
@onready var points : Label = $Points


var stats : PlayerStats = null

func load_stats(player_stats : PlayerStats) -> void:
	stats = player_stats
	



