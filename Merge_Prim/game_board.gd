extends Node2D

var height = 0
var width = 0
var max_cells = 0
var game_board = [] #-1 = Empty cell. Number = piece
var Empty = -1

var tween
var board_rect = Rect2i()

var cell = preload("res://game_cell.tscn")
var cell_location = []
var all_cells = []

signal clicked(cell_name, event)
var previous_click #To determine what the last move was

var game_piece = preload("res://game_piece.tscn")
var all_pieces = []

var score = 0
var level = 1
var level_score = level * 10

var bulb_count = 0
var bulb_highest = -1
var squirtle_count = 0
var squirtle_highest = -1
var char_count = 0
var char_highest = -1
var legend_count = 0
var legend_highest = -1

const generators = ["pokemart", "ruins", "game"] # "industry", 
const reverse_generators = ["chest"]# , "vending"
const immobile = ["grass"]
const unmergeable = ["chest", "grass"]
const dino = ["bulbasaur", "charmander", "squirtle", "legendary"]

const default_iteminfo = "Click a piece to get more info."

# Called when the node enters the scene tree for the first time.
func _ready():
	width = 7
	height = 9
	max_cells = height * width
	make_cells()
	make_gameboard()
	$game_cell.visible = false
	$active_selection.visible = false
	$GamePiece.visible = false
	$grass.visible = false
	make_piece("game", 8)
	#make_piece("industry", 8)
	populate_gameboard()
	display_score()
	$Control/lblItemInfo.bbcode_enabled = true
	$Control/lblItemInfo.text = default_iteminfo
	
func make_cells():
	#print("== GB Making Cells ==")
	for i in range(max_cells):
		var c = cell.instantiate()
		add_child(c)
		all_cells.append(c)
		c.id = i
		c.clicked.connect(_on_cell_clicked)

func make_gameboard():
	#print(" === GB Making Gameboard ===")
	var start_position_x
	var start_position_y = 130
	var cell_num = 0
	var cell_size = 0 
	cell_size = all_cells[0].get_node("cell").get_rect().size.x
	#Game is setup for a screen width of 720.
	start_position_x = (710 - (cell_size * width)) 
	for h in height:
		for w in width:
			var w_modifier = cell_size * w
			var h_modifier = cell_size * h
			all_cells[cell_num].position = Vector2(start_position_x + w_modifier, start_position_y + h_modifier)
			all_cells[cell_num].visible = true
			cell_location.append(all_cells[cell_num].position)
			game_board.append(Empty)
			cell_num += 1
			#print("Vector = ",w,", ", h)
	print("== GB make_gameboard: ", max_cells)
	print("   Cell_Locations = ", cell_location)

func make_piece(series, quantity):
	#print("== GB ", quantity, " piece(s) of family ", series, " to be made")
	for i in range(quantity):
		if all_pieces.size() < all_cells.size():
			var p = game_piece.instantiate()
			add_child(p)
			all_pieces.append(p)
			p.family = series
			match series:
				"chest":
					p.texture_index = 3 #Set to max_texture
				"crystal": 
					if level < 3:
						p.texture_index = randi_range(-1, 0)
					elif level >= 3 and level < 5:
						p.texture_index = randi_range(0, 1)
					elif level >= 5 and level < 8:
						p.texture_index = randi_range(1, 2)
					else:
						p.texture_index = randi_range(0, 3)
				"grass":
					p.texture_index = randi_range(-1, 1)
				"bulbasaur", "charmander", "squirtle":
					p.texture_index = -1 #Start at the beginning ONLY
				"legendary":
					p.texture_index = randi_range(-1, 8) #Any texture is allowed
				_:
					p.texture_index = randi_range(-1, 0)
			if reverse_generators.has(series):
				p.generator = "reverse"
			elif generators.has(series):
				p.generator = "forward"
			else:
				p.generator = ""
			#print("GB Make_Piece Generator = _", p.generator, "_")
			p.increment_texture()
			p.visible = true
		else:
			print("== GB Piece NOT made: Game board full")
			break
	pass

func populate_gameboard():
	var board_center = max_cells / 2
	for cell_num in range(all_pieces.size()):
		var closestMT = find_closest_empty_cell(board_center)
		place_piece(cell_num,closestMT)
		update_game_board()
	for cell_num in range(max_cells):
		if game_board[cell_num] == Empty:
			make_piece("grass", 1)
			place_piece(all_pieces.size()-1, cell_num)
	#print(" = GB Last Cell Location = ", cell_location[max_cells-1])
	#print(" = GB Last Piece Location = ", all_pieces[game_board[max_cells-1]].position)
	#print(" = GB Game Board initialized = ")
	pass

func place_piece(piece_id, new_cell, _old_cell = Empty):
	print("~~~GB Piece #", piece_id, " Placed @ Cell #", new_cell, "~~~")
	all_pieces[piece_id].id = new_cell
	all_pieces[piece_id].position = cell_location[new_cell]
	tween = create_tween()
	var new_position = cell_location[new_cell] - Vector2(0,4)
	tween.tween_property(all_pieces[piece_id], "position", new_position, 1)
	
func place_grass(cell_num):
	#print(" === GB Placing Grass ===")
	var g = $grass.instantiate()
	add_child(g)
	g.position = cell_location[cell_num]
	g.visible = true

func swap_pieces(new_cell, old_cell):
	#print("~~~GB Piece @ Cell #", old_cell, " swapped with piece @ ", new_cell, " ~~~")
	place_piece(game_board[new_cell], old_cell)
	previous_click = Vector2()
	pass

func update_game_board():
	game_board.clear()
	for i in range(max_cells):
		game_board.append(Empty)
	for i in range(all_pieces.size()):
		game_board[all_pieces[i].id] = i
	#print("=== GB Updated Game Board: ", game_board)
	print("=== GB Game Board Updated === ")

func find_empty_cell():
	#print("== GB Finding Empty Cell")
	for i in range(max_cells):
		if game_board[i] == Empty:
			return i
	return Empty
	#pass

func find_random_empty_cell():
	print("== GB Finding Random Empty Cell")
	var cell_vectors = []
	for i in range(max_cells):
		if game_board[i] == Empty:
			cell_vectors.append(i)
	if cell_vectors.size() > 0:
		cell_vectors.shuffle()
		return cell_vectors[0]
	else:
		return Empty
	#pass

func find_closest_family(origin, family, max_distance):
	#print("=== GB Finding Closest Family ===")
	var cell_vectors = []
	var closest_family = Empty
	for i in range(max_cells):
		if game_board[i] != Empty:
			if all_pieces[game_board[i]].family == family and i != origin:
				var magnitude = cell_location[origin].distance_to(cell_location[i])
				cell_vectors.append(magnitude)
			else:
				cell_vectors.append(5000)
		else:
			cell_vectors.append(5000)
	#print (" = GB There are ", family_count(family), " members of this family on the board")
	#print ("   GB family_cell_vectors = ", cell_vectors)
	var min = cell_vectors.min()
	#print (" = GB Closest Family is ", min, " distance")
	if min != 5000 and min < max_distance:
		for i in range(max_cells):
			if cell_vectors[i] == min:
				closest_family = i
				break
	#print (" - GB Origin is cell #", origin)
	#print (" - GB Closest Family is cell #", closest_family)
	return closest_family
	#pass

func find_closest_empty_cell(origin):
	#print("=== GB Finding Closest Empty Cell")
	#Make a game_board of vectors from origin to the target
	var cell_vectors = []
	var closest_mt_cell = Empty
	
	for i in range(max_cells):
		if game_board[i] == Empty:
			var cell_origin : Vector2
			var cell_destination : Vector2
			cell_origin = cell_location[origin]
			cell_destination = cell_location[i]
			var magnitude = cell_origin.distance_to(cell_destination)
			cell_vectors.append(magnitude)
		else:
			cell_vectors.append(5000)
	#print ("   GB cell_vectors = ", cell_vectors)
	var min = cell_vectors.min()
	if min != 5000:
		for i in range(max_cells):
			if cell_vectors[i] == min:
				closest_mt_cell = i
				break
				
	#print (" = GB Closest_mt_cell = ", closest_mt_cell)
	#print("GB Cell Vectors = ", cell_vectors)
	return closest_mt_cell
	#pass

func find_family(family):
	#print(" === GB Finding Family to Generate for ", family)
	match family:
		"pokemart":
			if randi_range(0, 10) != 10:
				return "pokeball"
			else:
				return "heal"
		"ruins":
			if randi_range(0, 10) != 10:
				return "fossil"
			else:
				return "stone"
		"industry":
			return "vending"
		#"vending":
		#	return "drink"
		"game":
			return "ruins"
		"fossil":
			return "fossil"
		"bulbasaur":
			return "bulbasaur"
		"charmander":
			return "charmander"
		"squirtle":
			return "squirtle"
		"legendary":
			return "legendary"
		"chest":
			var chance = randi_range(0,20)
			if chance < 11:
				return "pokemart"
			else:
				return "game"
		_:
			print("!!! GB Find_Family Error! !!!")
			return "error"

func merge_pieces(this_cell, prev_cell):
	#print(" === GB Merging ", this_cell, " and ", prev_cell, " ===")
	if all_pieces[game_board[this_cell]].increment_texture(): 
		#print(" = GB Merging ", this_cell, " incremented = ")
		#returns FALSE = NOT at max_texture for that family.
		#If it's NOT max_texture, we continue to affect the game_board.
		if all_pieces[game_board[this_cell]].texture_index > 3:
			var cellID = find_empty_cell()
			if  cellID != Empty:
				#print(" = GB Releasing Crystal = ")
				make_piece("crystal", 1) #Crystals are the experience points of the game.
				place_piece(all_pieces.size()-1,cellID)
			else:
				print(" = GB No Crystal! Game board full! = ")
		else:
			#print(" = GB Texture_index = ", all_pieces[game_board[this_cell]].texture_index)
			pass
		remove_piece(prev_cell)
	else:
		print(" !! GB Texture NOT incremented. Max texture!")

func generate_piece(click, click_family, where="closest"):
	#print(" === GB Generating Piece ", click_family, " at ", where, " empty cell ===")
	var empty_cell
	if where == "random":
		empty_cell = find_random_empty_cell()
	else:
		empty_cell = find_closest_empty_cell(click)

	if  empty_cell != Empty:
		var family = find_family(click_family)
		if  family != "error":
			make_piece(family, 1)
			place_piece(all_pieces.size()-1,empty_cell)
		else:
			print(" !!! GB Piece NOT Generated. Family = ERROR! !!!")
	else:
		print(" !! GB Generate ", click_family, " Failed. Game board full! !!!")

func remove_piece(cell_id):
	#print(" === GB Removing Piece @ ", cell_id)
	game_board[cell_id] = Empty
	for i in range(all_pieces.size()):
		if all_pieces[i].id == cell_id:
			print(" = Piece ID #", all_pieces[i].id, " Removed = ")
			all_pieces[i].queue_free()
			all_pieces.pop_at(i)
			break
		else:
			#print (all_cells[i].id, " != ", previous_click)
			pass

func calculate_score(texture_value):
	match texture_value:
		0:
			texture_value = 1
		1:
			texture_value = 4
		2:
			texture_value = 10
		3:
			texture_value = 22
		4:
			texture_value = 46
		5:
			texture_value = 94
	return texture_value

func update_score(cell_id):
	#print (" === GB Updating Score == ")
	var new_score
	var bonus_score = 0
	var texture_value = all_pieces[game_board[cell_id]].texture_index
	var family = all_pieces[game_board[cell_id]].family
	new_score = calculate_score(texture_value)
	print (" = GB New Score = ", new_score)
	if texture_value == 0:
		texture_value += 1
	if family == "rock":
		bonus_score = texture_value * 10
	print (" = GB Bonus Score = ", bonus_score)
	score += new_score + bonus_score
	#print(" = GB Updated Score = ", score, " & Level_score = ", level_score)
	if score >= level_score:
		#print(" = GB Level Up Granted!")
		var empty_cell = find_empty_cell()
		if empty_cell != Empty:
			make_piece("chest", 1) #Chests contain generator parts.
			place_piece(all_pieces.size()-1,empty_cell)
		else:
			print(" = GB No Chest! Game board full!")
		score = score - level_score
		level += 1
		level_score = level * 10
	else:
		#print(" GB Score < level_score")
		pass
	display_score()

func display_score():
	#print ("== GB Displaying Score == ")
	$Control/lblLevel.text = "Level " + str(level) + ": "
	$Control/prog_score.max_value = level_score
	$Control/prog_score.value = score
	$Control/lblScore.text = "Score " + str(score) + " of "+ str(level_score)
	#print("   Score = ", score, " Level = ", level)

func auto_generate():
	print("== GB Auto-Generate ==")
	for i in range(game_board.size()):
		if all_pieces[game_board[i]].family == "fossil":
			#print("   GB Family is Fossil ==")
			if all_pieces[game_board[i]].get_node("active").visible:
				print(" =  GB Fossil is Active =")
				var chance = randi_range(0,20)
				if chance < 5:
					generate_piece(all_pieces[game_board[i]].id, "bulbasaur", "random")
				elif chance > 5 and chance < 10:
					generate_piece(all_pieces[game_board[i]].id, "squirtle", "random")
				else:
					generate_piece(all_pieces[game_board[i]].id, "charmander", "random")
				var gencount = all_pieces[game_board[i]].decrement_gen_count()
				print("   GB GenCount is ", gencount, " ==")
				if gencount == Empty:
					remove_piece(i)
				update_game_board()
		elif all_pieces[game_board[i]].family == "ruins" and all_pieces[game_board[i]].texture_index == 6:
			if all_pieces[game_board[i]].get_node("active").visible:
				print(" =  GB Legendary Ruins are Active ==")
				var chance = randi_range(1,12)
				if chance < 3 and family_count("legendary") < 10:
					generate_piece(all_pieces[game_board[i]].id, "legendary", "random")

func is_dino_captured(click, pclick):
	var dino_texture = all_pieces[game_board[click]].texture_index
	var dino_family = all_pieces[game_board[click]].family
	var poke_texture = all_pieces[game_board[pclick]].texture_index
	
	print("   GB dino_family = ", dino_family)
	if dino_family == "bulbasaur":
		if poke_texture == dino_texture + 1:
			return true
	if dino_family == "squirtle":
		if poke_texture == dino_texture + 2:
			return true
	if dino_family == "charmander":
		if poke_texture == dino_texture + 3:
			return true
	if dino_family == "legendary":
		if poke_texture == dino_texture:
			return true

	return false

func capture_dino(click, pclick):
	print(" === GB Capturing Dino ", click, " by Pokeball @ ", pclick, " ===")
	var cellID = find_empty_cell()
	if  cellID != Empty:
		print(" = GB Releasing Rock = ")
		make_piece("rock", 1) #Rocks are the bonus XP of the game.
		place_piece(all_pieces.size()-1,cellID)
	else:
		print(" = GB No Rock Released! Game board full! = ")
	remove_piece(click)
	update_game_board()
	place_piece(game_board[pclick],click)
	animate_capture(click)

func animate_capture(click):
	update_game_board()
	tween = create_tween()
	tween.tween_property(all_pieces[game_board[click]], "rotation", 0.2, 0.2)
	tween.tween_property(all_pieces[game_board[click]], "rotation", 0, 0.2)
	#tween.tween_property(all_pieces[game_board[click]], "rotation", 10, 0.5)


func update_dino_counter(click_family, texture):
	$Notebook.update_stats(texture, click_family)
	pass
	
func update_iteminfo(click):
	#print(" === GB ItemInfo Updating ==")
	if previous_click != null:
		if game_board[click] == Empty and game_board[previous_click] == Empty:
			$Control/lblItemInfo.text = default_iteminfo
		elif game_board[click] == Empty and game_board[previous_click] != Empty:
			$Control/lblItemInfo.text = all_pieces[game_board[previous_click]].get_iteminfo()
		else:
			$Control/lblItemInfo.text = all_pieces[game_board[click]].get_iteminfo()
		#print("   GB Control_lblItemInfo = ", $Control/lblItemInfo.text)

func family_count(family):
	var count = 0
	for i in range(all_pieces.size()):
		if all_pieces[i].family == family:
			count +=1
	return count

func _on_cell_clicked(click, event):
	var is_left_click = false
	var is_1st_click = false
	var is_same_cell = false
	var is_same_texture = false
	var is_same_family = false
	var is_generator = false
	
	var pclick_family
	var pclick_texture
	var pclick_empty
	
	var click_family
	var click_empty
	var click_texture
	var click_generator
	
	var is_dino = false
	var was_pokeball = false

	#print("~~~~ GB On Cell Clicked @ ", click, "~~~~")
	#print("Cell Position = ", cell_location[cell_id])
	if event.is_action_pressed("left_mouse_click"):
		print (" == GB Initializing Click_* ")
		$active_selection.position = cell_location[click]
		$active_selection.visible = true
		is_left_click = true
		click_family = all_pieces[game_board[click]].family
		print(" GB click_family = ", click_family)
		if dino.has(click_family):
			is_dino = true
		click_texture = all_pieces[game_board[click]].texture_index
		click_generator = all_pieces[game_board[click]].generator
		#print(" = GB Click Generator Count = ", all_pieces[game_board[click]].generator_count)
		if all_pieces[game_board[click]].generator_count > Empty:
			is_generator = true

		if game_board[click] == Empty:
			click_empty = true
		else:
			click_empty = false
		if click_family != "grass":
			update_iteminfo(click)

	elif event.is_action_pressed("right_mouse_click"):
		print (" == GB OnCell Right Click ~~~")
		$active_selection.visible = false
		previous_click = null
		#print("  GB Previous_Click = ", previous_click)
	else:
		pass

	if is_left_click and !is_1st_click and previous_click != null:
		print("  GB Initializing PClick_* ")
		if game_board[previous_click] == Empty:
			pclick_empty = true
			pclick_family = ""
			pclick_texture = Empty
		else:
			pclick_empty = false
			pclick_family = all_pieces[game_board[previous_click]].family
			pclick_texture = all_pieces[game_board[previous_click]].texture_index
			if pclick_family == "pokeball":
				was_pokeball = true
	else:
		print("  GB First Click!")
		is_1st_click = true
	
	if click_empty and !pclick_empty and !is_1st_click and previous_click != null and !immobile.has(pclick_family):
		print("~~~GB ", click, " is Empty and ", previous_click, "is not empty.~~~")
		print("   GB Move to MT Cell")
		#animate_movement(previous_click, click)
		place_piece(game_board[previous_click], click, previous_click)

	if !is_1st_click: 
		if !click_empty and !pclick_empty and previous_click != click:
			print("   GB Both cells are occupied AND clicks are NOT the same cell")
		elif previous_click == click:
			is_same_cell = true
			print("  GB PClick = Click")
			if is_generator and click_family != "fossil":
				print("  GB ", click_family, " Generating")
				generate_piece(click, click_family)
				var gencount = all_pieces[game_board[click]].decrement_gen_count()
				print("  GB Generator Direction = ", click_generator)
				if click_generator == "forward":
					if gencount == Empty:
						all_pieces[game_board[click]].deactivate_generator()
						print("   GB Generator Waiting to Recharge.")
					else:
						print("   GB ", click_family, " gen_count = ", gencount)
				elif click_generator == "reverse": 
					if gencount == Empty:
						remove_piece(click)
						print("   GB Generator Removed.")
					else:
						print("   GB ", click_family, " gen_count = ", gencount)
				else:
					print("GB ", click_family, " is not a generator")
			else:
				print("  GB is_generator = ", is_generator, "; family = ", click_family)
				if click_family == "crystal" or click_family == "rock":
					print("   GB Crystal OR Rock Clicked Twice!")
					update_score(click)
					remove_piece(click)
		else:
			print("  GB Previous_click @ ", previous_click, " was empty")

	print(" = GB Click_texture = ", click_texture, " and pclick_texture = ", pclick_texture)
	if click_texture == pclick_texture:
		print("  GB Pieces have the SAME texture")
		is_same_texture = true
	else: 
		print("  GB Pieces have DIFFERENT textures")
		#swap_pieces(cell_id, previous_click)

	print(" = GB Click_family = ", click_family, " and pclick_family = ", pclick_family)
	if click_family == pclick_family:
		print("  GB Pieces are the SAME family")
		is_same_family = true
	else: 
		print("  GB Pieces are DIFFERENT families")
		print("  GB is_dino = ", is_dino, " & was_pokeball = ", was_pokeball)
		if is_dino and was_pokeball:
			if is_dino_captured(click, previous_click):
				print("  GB YOU CAUGHT A POKEMON!")
				update_dino_counter(click_family, click_texture)
				capture_dino(click, previous_click)

	if !unmergeable.has(click_family) and !is_1st_click and !is_same_cell and is_same_family and is_same_texture and !click_empty:
		print("  GB Mergeable!")
		merge_pieces(click, previous_click)
		update_game_board()
		update_iteminfo(click)
		var FAF = find_closest_family(click, "grass", 100)
		#print("  GB Closest Grass is ", FAF)
		if FAF != Empty:
			remove_piece(FAF)
			update_game_board()
			var family = find_family(click_family)
			if  family != "error":
				generate_piece(FAF, family)

	if is_left_click:
		previous_click = click
	#print("GB All_pieces = ", all_pieces)
	update_game_board()
	pass # Replace with function body.
	
	auto_generate()
