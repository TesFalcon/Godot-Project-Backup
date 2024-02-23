extends Node2D

var cell = preload("res://game_cell.tscn")
var game_piece = preload("res://game_piece.tscn")
var cell_location = {Vector2(): Vector2()}
var cell_area = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var height = 9
	var width = 7
	make_gameboard(height, width)
	populate_gameboard(height, width)
	
func make_gameboard(height, width):
	var start_position = 100.0
	for h in height:
		for w in width:
			var c = cell.instantiate()
			add_child(c)
			var w_modifier = c.get_rect().size.x / 4 * w
			var h_modifier = c.get_rect().size.y / 4 * h
			c.position = to_local(Vector2(start_position + w_modifier, start_position + h_modifier))
			cell_location[Vector2(w,h)]= to_local(c.position)
			print("Vector = ",w,", ", h)
	print("Cell_Location Dictionary = ", cell_location)
	
func populate_gameboard(height, width):
	for h in height:
		for w in width:
			var p = game_piece.instantiate()
			add_child(p)
			p.position = to_local(cell_location[Vector2(w,h)])
			#print("texture_index = ", p.texture_index)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	pass
	
	
