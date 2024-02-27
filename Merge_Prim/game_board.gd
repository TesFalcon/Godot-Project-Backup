extends Node2D

var height = 0
var width = 0

var cell = preload("res://game_cell.tscn")
var cell_location = {Vector2(): Vector2()}
var all_cells = []

signal clicked(cell_name, event)
var cell_clicked = false
var clicked_array = [] #To determine what the last move was

var game_piece = preload("res://game_piece.tscn")
var all_pieces = []
var piece_location = {Vector2(): 0}

# Called when the node enters the scene tree for the first time.
func _ready():
	height = 2
	width = 2
	make_cell()
	make_gameboard()
	$game_cell.visible = false
	$active_selection.visible = false
	$GamePiece.visible = false
	populate_gameboard()

func make_cell():
	var max_cells = height * width
	for i in range(max_cells):
		var c = cell.instantiate()
		add_child(c)
		all_cells.append(c)
	print("GB make_cell ", max_cells, " cells added to all_cells")
	pass
	
func make_gameboard():
	var start_position = 100.0
	var cell_num = 0
	var cell_size = 0 
	for h in height:
		for w in width:
			cell_size = all_cells[cell_num].get_node("cell").get_rect().size.x / 4
			var w_modifier = cell_size * w + 50
			var h_modifier = cell_size * h
			if cell_num < height * width:
				all_cells[cell_num].position = to_local(Vector2(start_position + w_modifier, start_position + h_modifier))
				all_cells[cell_num].visible = true
				all_cells[cell_num].my_name = Vector2(w,h)
				all_cells[cell_num].clicked.connect(_on_cell_clicked)
				cell_location[Vector2(w,h)]= all_cells[cell_num].position
			cell_num += 1
			#print("Vector = ",w,", ", h)
	print("GB make_gameboard Cell_Location Dictionary = ", cell_location)
	
func populate_gameboard():
	var max_cells = height * width
	for i in range(max_cells):
		var p = game_piece.instantiate()
		add_child(p)
		all_pieces.append(p)
	print("GB populate_gameboard", max_cells, " pieces added to all_pieces")
	var cell_num = 0
	for h in height:
		for w in width:
			if cell_num < height * width:
				all_pieces[cell_num].position = to_local(cell_location[Vector2(w,h)])
		#piece position is off just a little bit. 
				all_pieces[cell_num].position = all_pieces[cell_num].position + Vector2(5,35)
		#This line ^-^-^ is to nudge it into a more accurate overlay position with the cell.
				all_pieces[cell_num].my_name = Vector2(w,h)
				all_pieces[cell_num].texture_index = 0
				all_pieces[cell_num].visible = true
				#all_pieces[cell_num].clicked.connect(_on_cell_clicked)
				piece_location[Vector2(w,h)] = all_pieces[cell_num].texture_index
				cell_num += 1
			#print("Vector = ",w,", ", h)
	print("GB populate_gameboard Piece_Location Dictionary = ", piece_location)
	pass

func update_gameboard():
	var cell_num = 0
	piece_location.clear()
	for h in height:
		for w in width:
			if cell_num < height * width:
				if all_pieces[cell_num].my_name == Vector2(w,h):
						all_pieces[cell_num].position = to_local(cell_location[Vector2(w,h)])
						#piece position is off just a little bit. 
						all_pieces[cell_num].position = all_pieces[cell_num].position + Vector2(5,35)
						#This line ^-^-^ is to nudge it into a more accurate overlay position with the cell.
						piece_location[Vector2(w,h)] = all_pieces[cell_num].texture_index
				cell_num += 1
			#print("Vector = ",w,", ", h)	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#update_gameboard()
	pass

func _input(event):
	if event.is_action_pressed("left_mouse_click"):
		#print("GB Click Location: ", to_local(event.position))
		if !cell_clicked:
			$active_selection.visible = false
	pass
	
func _on_cell_clicked(cell_name, event):
	# cell_name = current click
	var previous_click = Vector2()
	cell_clicked = true
	print("GB On Cell Clicked = ", cell_name)
	clicked_array.append(cell_name)
	#print("Cell Position = ", cell_location[cell_name])
	if event.is_action_pressed("left_mouse_click"):
		print ("GB OnCell Left Click")
		$active_selection.position = cell_location[cell_name]
		#Active_selection position is off just a little bit. 
		$active_selection.position = $active_selection.position - Vector2(5,5)
		#This line ^-^-^ is to nudge it into a more accurate overlay position with the cell.
		$active_selection.visible = true
		if clicked_array.size() > 1:
			previous_click = clicked_array[-2]
			print("GB Previous_click = ", previous_click)
			if clicked_array.has(cell_name) and piece_location.has(cell_name):
				print("GB Cell is occupied.")
				if piece_location.has(previous_click) and previous_click != cell_name:
					print("GB Both cells are occupied.")
					if piece_location[cell_name] == piece_location[previous_click]:
						print("GB Both cells have the same texture.")
						print("GB all_cells.size = ", all_cells.size())
						for i in range(all_cells.size()):
							#print("GB all_cells.size = ", all_cells.size())
							if all_cells[i].my_name == Vector2(cell_name):
								print("GB Cell number index with same name = ", i)
								for r in range(all_pieces.size()):
									print("GB Piece name = ", all_pieces[r].my_name)
									if all_pieces[r].my_name == Vector2(cell_name):
										all_pieces[r].increment_texture()
										piece_location[cell_name] = all_pieces[r].texture_index
										break
								break
							else:
								print ("GB ", all_cells[i].my_name, " != ", previous_click)
						if piece_location.erase(previous_click):
							print("GB Previous Piece Erased.")
							pass
						else:
							print("GB Previous piece NOT erased")
							pass
						print("GB all_pieces.size = ", all_pieces.size())
						for i in range(all_pieces.size()):
							print("GB Piece name = ", all_pieces[i].my_name)
							if all_pieces[i].my_name == previous_click:
								all_pieces[i].queue_free()
								all_pieces.pop_at(i)
								break
							else:
								print (all_cells[i].my_name, " != ", previous_click)
					else: 
						print("GB Pieces are different")
				else: 
					print("GB ", previous_click, " was empty")
			else:
				print("GB ", cell_name, " is Empty")
			print("GB All_pieces = ", all_pieces)
			print("GB Piece_Locations = ", piece_location)
		else:
			print("GB First Click!")
	elif event.is_action_pressed("right_mouse_click"):
		print ("GB OnCell Right Click")
		print("GB Clicked Array = ", clicked_array)
		$active_selection.visible = false
	else:
		pass
	pass # Replace with function body.

