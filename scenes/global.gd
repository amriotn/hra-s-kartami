extends Node

var player_stats_resources : Array = []
var player_list : Array = []


const icons : Array = ["res://assets/characters/KnightIcon.png", "res://assets/characters/AdventurerIcon.png"]
const characters : Array = ["res://assets/characters/Knight.png", "res://assets/characters/Adventurer.png"]

var card_player_target

func update_stats():
	for stat in player_stats_resources:
		stat.emit_signal("stats_updated")


func update_leaders():
	var leaderboard : Array
	for stat in player_stats_resources:
		leaderboard.append(stat)
	print(leaderboard)
	
	var n : int = leaderboard.size()

	# One by one move boundary of unsorted subarray 
	var i = 0
	while i < n-1: 
	# Find the minimum element in unsorted array 
		var min_idx : int = i; 
		var j : int = i+1
		while j < n: 
			if leaderboard[j].points < leaderboard[min_idx].points:
				min_idx = j
			j += 1

# Swap the found minimum element with the first element 
		var temp = leaderboard[min_idx] 
		leaderboard[min_idx] = leaderboard[i] 
		leaderboard[i] = temp
		i += 1
	
	print(leaderboard)
	for stat in leaderboard:
		stat.leaderboard_position = leaderboard.find(stat)
	
	


