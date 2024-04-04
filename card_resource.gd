class_name CardResource
extends Resource

enum Target {SELF, SINLGE_ENEMY, ALL_ENEMIES, EVERYONE, AREA, ENVIRONMENT}
enum Rarity {COMMON, RARE, EPIC, LEGENDARY}
var Rarity_colors : Array = [Color.GRAY, Color.BLUE, Color.WEB_PURPLE, Color.GOLDENROD]

@export_group("Card Attributes")
@export var points : int
@export var target : Target
@export var rarity : Rarity
var color : Color = Rarity_colors[rarity]

@export_group("Card Visuals")
@export var icon : Texture
@export var card_name : String
@export_multiline var description : String
