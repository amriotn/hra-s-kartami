class_name CardResource
extends Resource

const card_effect = preload("res://card_effect.gd")
var new_effect : CardEffect = card_effect.new()

enum Target {SELF, SINLGE_ENEMY, ALL_ENEMIES, EVERYONE, AREA, ENVIRONMENT}
enum Rarity {COMMON, RARE, EPIC, LEGENDARY}
const Rarity_colors : Array = [Color.GRAY, Color.BLUE, Color.WEB_PURPLE, Color.GOLDENROD]
enum Effect {GIVE_CARD}

@export_group("Card Attributes")
@export var points : int
@export var rarity : Rarity
@export_subgroup("Effect Attributes")
@export var effect : Effect # GIVE CARD
@export var effect_data : int # 3 CARDS
@export var effect_target : Target # IN AREA
@export var effect_target_data : int # AREA OF 5 TILES
var holder : Player
var color : Color = Rarity_colors[rarity]

@export_group("Card Visuals")
@export var icon : Texture
@export var card_name : String
@export_multiline var description : String

func _init():
	new_effect.card_data = self
	new_effect.effect = effect
	new_effect.effect_data = effect_data
	new_effect.effect_target = effect_target
	new_effect.effect_target_data = effect_target_data
	print("Card resource init")


func trigger_effect():
	new_effect.trigger_effect()
