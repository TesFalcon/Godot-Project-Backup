extends Node2D

@export var id = ""

signal clicked(my_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	#$cell.position = Vector2(100,100)
	$cell.texture = load("res://PokeMerge/cell_64.png")
	$cell.visible = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseMotion:
		#print ("Mouse In Motion")
		pass
	if event is InputEventMouseButton:
		#print ("Game Cell Mouse Button Event")
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print ("GC Left_Click")
			clicked.emit(id, event)
		elif !event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#print ("GC Left_Click_Released")
			pass
		elif event.pressed and  event.button_index == MOUSE_BUTTON_RIGHT:
			print ("GC Right_Click")
			clicked.emit(id, event)
		elif !event.pressed and  event.button_index == MOUSE_BUTTON_RIGHT:
			#print ("GC Right_Click_Released")
			pass
		else:
			print("GC Some Other Mouse Event")
	pass # Replace with function body.
