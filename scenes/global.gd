extends Node

var player_stats_resources : Array = []
var player_list : Array = []


const icons : Array = ["res://assets/characters/KnightIcon.png", "res://assets/characters/AdventurerIcon.png"]
const characters : Array = ["res://assets/characters/Knight.png", "res://assets/characters/Adventurer.png"]

var card_player_target

func update_stats():
	for stat in player_stats_resources:
		stat.emit_signal("stats_updated")



