extends Control

@onready var select_gradient = $SelectGradient

@onready var player_icon : Sprite2D = $PlayerIcon
@onready var leaderboard_position : Label = $Position
@onready var nickname : Label = $Nickname
@onready var points : Label = $Points


var stats : PlayerStats = null

func load_stats(player_stats : PlayerStats) -> void:
	stats = player_stats

var points_sum = 0
func on_stats_updated():
	points_sum = 0
	print("stats updated")
	for card in stats.hand.get_children():
		points_sum += card.data.points
	points.text = str(points_sum)
	stats.points = points_sum
	print(Global.player_stats_resources)
	print(Global.player_stats_resources.find(stats))
	Global.player_stats_resources.sort_custom(custom_sort)
	print(Global.player_stats_resources)
	
	leaderboard_position.text = str(Global.player_stats_resources.find(stats)+1)
	
	
	
	
func custom_sort(a, b):
	if a.points > b.points:
		return true
	return false

