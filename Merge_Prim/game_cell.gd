extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = load("res://PokeMerge/cell.png")
	$selected.visible = false
	position = Vector2(100,100)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			print("Game_cell clicked!")
			$selected.position = position
			$selected.visible = true
		else:
			$selected.visible = false
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		$selected.visible = false
		
