class_name CardResource
extends Resource

const card_effect = preload("res://card_effect.gd")
var new_effect : CardEffect = card_effect.new()

enum Target {SELF, SINLGE_ENEMY, ALL_ENEMIES, EVERYONE, AREA, ENVIRONMENT}
enum Rarity {COMMON, RARE, EPIC, LEGENDARY}
const Rarity_colors : Array = [Color.GRAY, Color.BLUE, Color.WEB_PURPLE, Color.GOLDENROD]
enum Effect {GIVE_CARD, GIVE_IMMUNITY}

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


func trigger_effect():
	new_effect.trigger_effect(self)

func create_instance():
	var instance : CardResource = CardResource.new()
	instance.points = points
	instance.rarity = rarity
	instance.effect = effect
	instance.effect_data = effect_data
	instance.effect_target = effect_target
	instance.effect_target_data = effect_target_data
	
	instance.icon = icon
	instance.card_name = card_name
	instance.description = description
	#instance.holder = card_holder
	instance.new_effect = instance.new_effect.create_instance(self)
	return instance
