extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		if get_viewport_rect().has_point(to_local(event.position)):
			print("You selected:", self.name)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		print("You selected:")
