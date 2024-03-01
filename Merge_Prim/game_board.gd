extends Node2D

var height = 0
var width = 0
var max_cells = 0
var game_board = [] #-1 = Empty cell. Number = piece
var Empty = -1

var cell = preload("res://game_cell.tscn")
var cell_location = []
var all_cells = []

signal clicked(cell_name, event)
signal activate_generator(id)

var clicked_array = [] #To determine what the last move was

var game_piece = preload("res://game_piece.tscn")
var all_pieces = []

# Called when the node enters the scene tree for the first time.
func _ready():
	width = 4
	height = 4
	max_cells = height * width
	make_cells()
	make_gameboard()
	$game_cell.visible = false
	$active_selection.visible = false
	$GamePiece.visible = false
	if max_cells > 8:
		make_piece("pokemart", 8)
	else:
		make_piece("pokemart", max_cells)
	populate_gameboard()

func make_cells():
	for i in range(max_cells):
		var c = cell.instantiate()
		add_child(c)
		all_cells.append(c)
	
func make_gameboard():
	var start_position_x = -100
	var start_position_y = -200
	var cell_num = 0
	var cell_size = 0 
	for h in height:
		for w in width:
			cell_size = all_cells[cell_num].get_node("cell").get_rect().size.x / 4
			var w_modifier = cell_size * w + 5
			var h_modifier = cell_size * h
			if cell_num < height * width:
				all_cells[cell_num].position = to_global(Vector2(start_position_x + w_modifier, start_position_y + h_modifier))
				all_cells[cell_num].visible = true
				all_cells[cell_num].id = cell_num
				all_cells[cell_num].clicked.connect(_on_cell_clicked)
				cell_location.append(all_cells[cell_num].position)
				game_board.append(Empty)
			cell_num += 1
			#print("Vector = ",w,", ", h)
	print("GB make_gameboard Cell_Locations = ", cell_location)

func make_piece(series, quantity):
	for i in range(quantity):
		var p = game_piece.instantiate()
		add_child(p)
		all_pieces.append(p)
		p.texture_index = Empty
		p.family = series
		p.increment_texture()
		p.visible = true
		p.activate_generator.connect(_on_activate_generator)
	print("GB ", quantity, " piece(s) of family ", series, " made and added to all_pieces")
	pass

func populate_gameboard():
	for cell_num in range(all_pieces.size()):
		place_piece(cell_num,cell_num,Empty)
		game_board[cell_num] = cell_num
		#print("Vector = ",w,", ", h)
	print("GB initial game_board = ", game_board)
	pass

func place_piece(piece_id, new_cell, old_cell):
	print("~~~GB Piece #", piece_id, " Placed @ Cell #", new_cell, "~~~")
	all_pieces[piece_id].id = new_cell
	all_pieces[piece_id].position = cell_location[new_cell]
	#piece position is off just a little bit. 
	all_pieces[piece_id].position = all_pieces[piece_id].position + Vector2(-7,-9)
	#This line ^-^-^ is to nudge it into a more accurate overlay position with the cell.

func swap_pieces(new_cell, old_cell):
	place_piece(game_board[old_cell], new_cell, Empty)
	place_piece(game_board[new_cell], old_cell, Empty)
	clicked_array.clear()
	pass

func update_game_board():
	game_board.clear()
	for i in range(max_cells):
		game_board.append(Empty)
	for i in range(all_pieces.size()):
		game_board[all_pieces[i].id] = i

func find_empty_cell():
	for i in range(max_cells):
		if game_board[i] == Empty:
			return i
	return Empty
	pass

func find_family(family):
	match family:
		"pokemart":
			if randi_range(0, 5) != 5:
				return "pokeball"
			else:
				return "heal"
		_:
			print("GB Find_Family Error!")
			return "error"
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#update_gameboard()
	pass

func _input(event):
	if event.is_action_pressed("left_mouse_click"):
		#print("GB Click Location: ", to_local(event.position))
		pass
	
func _on_cell_clicked(cell_id, event):
	# cell_id = current click
	var previous_click = Vector2()
	print("~~~~GB On Cell Clicked = ", cell_id, "~~~~")
	clicked_array.append(cell_id)
	#print("Cell Position = ", cell_location[cell_id])
	if event.is_action_pressed("left_mouse_click"):
		#print ("GB OnCell Left Click")
		$active_selection.position = cell_location[cell_id]
		#Active_selection position is off just a little bit. 
		$active_selection.position = $active_selection.position - Vector2(5,7)
		#This line ^-^-^ is to nudge it into a more accurate overlay position with the cell.
		$active_selection.visible = true
		if clicked_array.size() > 1:
			previous_click = clicked_array[-2]
			print("GB Previous_click = ", previous_click)
			if clicked_array.has(cell_id) and game_board[cell_id] != Empty:
				print("GB Cell is occupied.")
				if game_board[previous_click] != Empty and previous_click != cell_id:
					print("GB Both cells are occupied.")
					if all_pieces[game_board[cell_id]].texture_index == all_pieces[game_board[previous_click]].texture_index:
						print("GB Both cells have the same texture.")
						if all_pieces[game_board[cell_id]].family == all_pieces[game_board[previous_click]].family:
							all_pieces[game_board[cell_id]].increment_texture()
							game_board[previous_click] = Empty
							print("GB all_pieces.size = ", all_pieces.size())
							for i in range(all_pieces.size()):
								if all_pieces[i].id == previous_click:
									print("GB Piece ID Removed = ", all_pieces[i].id)
									all_pieces[i].queue_free()
									all_pieces.pop_at(i)
									break
								else:
									#print (all_cells[i].id, " != ", previous_click)
									pass
						else: 
							print("==GB Pieces are different families==")
							print("Cell family = ", all_pieces[game_board[cell_id]].family)
							print("Previous Cell family = ", all_pieces[game_board[previous_click]].family)
							#swap_pieces(cell_id, previous_click)
					else: 
						print("GB Pieces are in different textures")
						#swap_pieces(cell_id, previous_click)
				elif previous_click == cell_id:
					print("!!!It's a generator = ", all_pieces[game_board[cell_id]].generator, "!!!")
					if all_pieces[game_board[cell_id]].generator:
						if find_empty_cell() != Empty:
							make_piece(find_family(all_pieces[game_board[cell_id]].family), 1)
							place_piece(all_pieces.size()-1,find_empty_cell(),Empty)
						else:
							print("Game board full!")
				else:
					print("GB ", previous_click, " was empty")
			else:
				print("~~~GB Cell #", cell_id, " is Empty~~~")
				if game_board[previous_click] != Empty:
					for i in range(all_pieces.size()):
						#print("GB Piece name = ", all_pieces[i].id)
						if all_pieces[i].id == previous_click:
							place_piece(i, cell_id, previous_click)
							break
						else:
							#print (all_cells[i].id, " != ", previous_click)
							pass
					pass
			print("GB All_pieces = ", all_pieces)
			update_game_board()
			print("GB Game_board = ", game_board)
		else:
			print("GB First Click!")
	elif event.is_action_pressed("right_mouse_click"):
		print ("~~~GB OnCell Right Click~~~")
		print("GB Clicked Array = ", clicked_array)
		$active_selection.visible = false
		clicked_array.clear()
	else:
		pass
	pass # Replace with function body.

func _on_activate_generator(id):
	var cell_id = id
	var piece_id = game_board[id]
	print("~~~GB Activate Generator~~~")
	print("GB Cell Position = ", cell_location[cell_id])
	print("GB Local Cell Position = ", to_local(cell_location[cell_id]))
	print("GB Global Cell position = ", to_global(cell_location[cell_id]))
	print("GB Piece Position = ", all_pieces[piece_id].position)
	print("GB Local Piece Position = ", to_local(all_pieces[piece_id].position))
	print("GB Global Piece position = ", to_global(all_pieces[piece_id].position))
	
	all_pieces[piece_id].get_node("active").position = all_pieces[piece_id].position
	#active position is off just a little bit. 
	#all_pieces[piece_id].get_node("active").position = all_pieces[piece_id].get_node("active").position + Vector2(55,235)
	#This line ^-^-^ is to nudge it into a more accurate overlay position with the piece.
	all_pieces[piece_id].get_node("active").visible = true
	all_pieces[piece_id].generator = true
	pass # Replace with function body.
