extends Node2D

var height : int = 9
var width : int = 8
var max_cells : int = height * width
var game_board : Array[int] #-1 = Empty cell. Number = piece
var Empty : int = -1

var tween
var board_rect := Rect2i()

var cell : PackedScene = preload("res://game_cell.tscn")
var cell_location := []
var all_cells := []

# dino holding cells for after the pokemon are captured.
var holding_height : int = 2
var holding_width : int = 3
var holding_max_cells : int = holding_height * holding_width
var holding_cells := [] # Equivalent of all_cells
var holding_locations := [] # Equivalent of cell_locations
var holding_pieces := [] # Equivalent of all_pieces

#signal clicked(cell_name, event)
var previous_click #To determine what the last move was

var game_piece : PackedScene = preload("res://game_piece.tscn")
var all_pieces := []

var score : int = 0
var level : int = 1
var level_score : int = level * 10

var bulb_count : int = 0
var bulb_highest : int = -1
var squirtle_count : int = 0
var squirtle_highest : int = -1
var char_count : int = 0
var char_highest : int = -1
var legend_count : int = 0
var legend_highest : int = -1
var next_legend : int = Empty - 1 #Initialize to less than Empty. First action is to increment to Empty.

const generators : Array = ["pokemart", "ruins", "game"] # "industry",
const reverse_generators : Array = ["chest"]# , "vending"
const immobile : Array = ["grass"]
const unmergeable : Array = ["chest", "grass"]
const dino : Array = ["bulbasaur", "charmander", "squirtle", "legendary"]

const default_iteminfo : String = "Click a piece to get more info."

# Called when the node enters the scene tree for the first time.
func _ready():
	make_cells()
	make_gameboard()
	$game_cell.visible = false
	$active_selection.visible = false
	$GamePiece.visible = false
	$grass.visible = false
	make_piece("game", 9)
	make_piece("pokemart", 8)
	populate_gameboard()
	display_score()
	make_dino_holding_cells(holding_max_cells)
	update_dino_holding_cells()
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
	var start_position_x : int
	var start_position_y : int = $Control/lblInstructions.position.y
	var cell_num : int = 0
	var cell_size : int = 0
	cell_size = all_cells[0].get_node("cell").get_rect().size.x
	#Game is setup for a screen width of 1280.
	start_position_x = (1280 - (cell_size * width)) / 2
	for h : int in height:
		for w : int in width:
			var w_modifier : int = (cell_size + 1) * w
			var h_modifier : int = (cell_size + 1) * h
			all_cells[cell_num].position = Vector2(start_position_x + w_modifier, start_position_y + h_modifier)
			all_cells[cell_num].visible = true
			cell_location.append(all_cells[cell_num].position)
			game_board.append(Empty)
			cell_num += 1
			#print("Vector = ",w,", ", h)
	print("== GB make_gameboard: ", max_cells)
	print("   Cell_Locations = ", cell_location)

func make_piece(series, quantity, texture = Empty):
	#print("== GB ", quantity, " piece(s) of family ", series, " to be made")
	for i in range(quantity):
		if all_pieces.size() < all_cells.size():
			var p = game_piece.instantiate()
			add_child(p)
			all_pieces.append(p)
			p.family = series
			if texture == Empty:
				match series:
					"grass":
						p.texture_index = randi_range(-1, 1)
					"bulbasaur", "charmander", "squirtle":
						p.texture_index = Empty #Start at the beginning ONLY
					"legendary":
						next_legend += 1
						if $Notebook.is_max_texture("legendary", next_legend):
							next_legend = -1
						p.texture_index = next_legend
					_:
						p.texture_index = randi_range(-1, 0)
			else:
				p.texture_index = texture
			if reverse_generators.has(series):
				p.generator = "reverse"
			elif generators.has(series):
				p.generator = "forward"
			else:
				p.generator = ""
			p.increment_texture()
			p.visible = true
		else:
			print("== GB Piece NOT made: Game board full")
			break
	pass

func populate_gameboard():
	var board_center : int = max_cells / 2
	for cell_num : int in range(all_pieces.size()):
		var closestMT : int = find_closest_empty_cell(board_center)
		place_piece(cell_num,closestMT,board_center)
		update_game_board()
	for cell_num : int in range(max_cells):
		if game_board[cell_num] == Empty:
			make_piece("grass", 1)
			place_piece(all_pieces.size()-1, cell_num, board_center)
	#print(" = GB Game Board initialized = ")

func place_piece(piece_id, new_cell, start_cell = Empty):
	print("~~~GB Piece #", piece_id, " Placed @ Cell #", new_cell, "~~~")
	all_pieces[piece_id].id = new_cell
	if start_cell == Empty:
		#print(" GB Old_cell = Empty ")
		all_pieces[piece_id].position = cell_location[cell_location.size()-1]
	else:
		#print(" GB Old_cell = ", start_cell)
		all_pieces[piece_id].position = cell_location[start_cell]
	animate_move(piece_id, start_cell, new_cell)

func animate_move(piece_id, start_cell, end_cell):
	all_pieces[piece_id].position = cell_location[start_cell]
	tween = create_tween()
	var new_position = cell_location[end_cell] - Vector2(0,4)
	tween.tween_property(all_pieces[piece_id], "position", new_position, 0.25)

func update_game_board():
	game_board.clear()
	for i in range(max_cells):
		game_board.append(Empty)
	for i in range(all_pieces.size()):
		game_board[all_pieces[i].id] = i
	#print("=== GB Updated Game Board: ", game_board)
	print("=== GB Game Board Updated === ")

func find_empty_cell() -> int:
	#print("== GB Finding Empty Cell")
	for i in range(max_cells):
		if game_board[i] == Empty:
			return i
	return Empty
	#pass

func find_random_empty_cell() -> int:
	print("== GB Finding Random Empty Cell")
	var cell_vectors := []
	for i in range(max_cells):
		if game_board[i] == Empty:
			cell_vectors.append(i)
	if cell_vectors.size() > 0:
		cell_vectors.shuffle()
		return cell_vectors[0]
	else:
		return Empty
	#pass

func find_closest_family(origin, family, max_distance) -> int:
	#print("=== GB Finding Closest Family ===")
	var cell_vectors := []
	var closest_family : int = Empty
	for i in range(max_cells):
		if game_board[i] != Empty:
			if all_pieces[game_board[i]].family == family and i != origin:
				var magnitude : float = cell_location[origin].distance_to(cell_location[i])
				cell_vectors.append(magnitude)
			else:
				cell_vectors.append(5000)
		else:
			cell_vectors.append(5000)
	#print (" = GB There are ", family_count(family), " members of this family on the board")
	#print ("   GB family_cell_vectors = ", cell_vectors)
	var cell_min = cell_vectors.min()
	#print (" = GB Closest Family is ", min, " distance")
	if cell_min != 5000 and cell_min < max_distance:
		for i in range(max_cells):
			if cell_vectors[i] == cell_min:
				closest_family = i
				break
	#print (" - GB Origin is cell #", origin)
	#print (" - GB Closest Family is cell #", closest_family)
	return closest_family
	#pass

func find_closest_empty_cell(origin) -> int:
	#print("=== GB Finding Closest Empty Cell")
	#Make a game_board of vectors from origin to the target
	var cell_vectors := []
	var closest_mt_cell : int = Empty
	
	for i in range(max_cells):
		if game_board[i] == Empty:
			var cell_origin : Vector2
			var cell_destination : Vector2
			cell_origin = cell_location[origin]
			cell_destination = cell_location[i]
			var magnitude : float = cell_origin.distance_to(cell_destination)
			cell_vectors.append(magnitude)
		else:
			cell_vectors.append(5000)
	#print ("   GB cell_vectors = ", cell_vectors)
	var cell_min = cell_vectors.min()
	if cell_min != 5000:
		for i in range(max_cells):
			if cell_vectors[i] == cell_min:
				closest_mt_cell = i
				break
				
	#print (" = GB Closest_mt_cell = ", closest_mt_cell)
	#print("GB Cell Vectors = ", cell_vectors)
	return closest_mt_cell
	#pass

func find_family(family) -> String:
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
			var chance : int = randi_range(0,20)
			if chance < 11:
				return "pokemart"
			else:
				return "game"
		_:
			print("!!! GB Find_Family Error! !!!")
			return "error"

func merge_pieces(this_cell, prev_cell):
	#print(" === GB Merging ", this_cell, " and ", prev_cell, " ===")
	$snd_Merge.play()
	if all_pieces[game_board[this_cell]].increment_texture(): 
		#print(" = GB Merging ", this_cell, " incremented = ")
		#returns FALSE = NOT at max_texture for that family.
		#If it's NOT max_texture, we continue to affect the game_board.
		if all_pieces[game_board[this_cell]].texture_index > 3:
			var cellID : int = find_closest_empty_cell(this_cell)
			if  cellID != Empty:
				#print(" = GB Releasing Crystal = ")
				var crystal_level : int
				if level < 3:
					crystal_level = randi_range(-1, 0)
				elif level >= 3 and level < 5:
					crystal_level = randi_range(0, 1)
				elif level >= 5 and level < 8:
					crystal_level = randi_range(1, 2)
				else:
					crystal_level = randi_range(0, 3)
				make_piece("crystal", 1, crystal_level) #Crystals are the experience points of the game.
				place_piece(all_pieces.size()-1,cellID,this_cell)
				$snd_XP.play()
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
		var family : String = find_family(click_family)
		if  family != "error":
			make_piece(family, 1)
			place_piece(all_pieces.size()-1,empty_cell,click)
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
	var new_score : int
	var bonus_score : int = 0
	var texture_value : int = all_pieces[game_board[cell_id]].texture_index
	var family : String = all_pieces[game_board[cell_id]].family
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
		var empty_cell : int = find_empty_cell()
		if empty_cell != Empty:
			var chest_level : int = 3 #Chests have 4 image levels. 3 is the top.
			make_piece("chest", 1, chest_level) #Chests contain generator parts.
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
	for i : int in range(game_board.size()):
		if all_pieces[game_board[i]].family == "fossil":
			#print("   GB Family is Fossil ==")
			if all_pieces[game_board[i]].get_node("active").visible:
				print(" =  GB Fossil is Active =")
				$snd_NewDino.play()
				var chance : int = randi_range(0,20)
				if chance < 5:
					generate_piece(all_pieces[game_board[i]].id, "bulbasaur", "random")
				elif chance > 5 and chance < 10:
					generate_piece(all_pieces[game_board[i]].id, "squirtle", "random")
				else:
					generate_piece(all_pieces[game_board[i]].id, "charmander", "random")
				var gencount : int = all_pieces[game_board[i]].decrement_gen_count()
				print("   GB GenCount is ", gencount, " ==")
				if gencount == Empty:
					remove_piece(i)
				update_game_board()
		elif all_pieces[game_board[i]].family == "ruins" and all_pieces[game_board[i]].texture_index > 5:
			if all_pieces[game_board[i]].get_node("active").visible:
				print(" =  GB Ruins are Active ==")
				var tex_ndx : int = Empty
				match all_pieces[game_board[i]].texture_index:
					6:
						tex_ndx = randi_range(-1,1)
					7:
						tex_ndx = randi_range(2,4)
					8: 
						tex_ndx = randi_range(5,7)
				var chance : int = randi_range(1,12)
				if chance < 3 and family_count("legendary") < 5:
					$snd_NewDino.play()
					make_piece("legendary", 1, tex_ndx)
					var empty_cell : int = find_random_empty_cell()
					place_piece(all_pieces.size()-1,empty_cell,i)

func family_count(family) -> int:
	var count : int = 0
	for i : int in range(all_pieces.size()):
		if all_pieces[i].family == family:
			count +=1
	return count

func is_dino_captured(click, pclick) -> bool:
	var dino_texture : int = all_pieces[game_board[click]].texture_index
	var dino_family : String = all_pieces[game_board[click]].family
	var poke_texture : int = all_pieces[game_board[pclick]].texture_index
	
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
	$snd_Backpack.play()
	var cellID : int = find_closest_empty_cell(click)
	if  cellID != Empty:
		print(" = GB Releasing Rock = ")
		$snd_Recharge.play()
		make_piece("rock", 1, -1) #Rocks are the bonus XP of the game.
		place_piece(all_pieces.size()-1,cellID)
	else:
		print(" = GB No Rock Released! Game board full! = ")
	remove_piece(click)
	update_game_board()
	place_piece(game_board[pclick],click)
	print(" GB Moving to Holding Cell ")
	shift_holding_pieces()
	move2_holding_cell(game_board[pclick],click)
	
func shift_holding_pieces():
	print("=== GB Shifting Holding Board Down 1 to Make Room === ")
	var last_pokeball = holding_pieces[holding_pieces.size()-1]
	if last_pokeball != null:
		last_pokeball.free()
	#Starting w the 2nd to last element, reverse through the pieces array
	for i in range((holding_pieces.size()-2), -1, -1): 
		if holding_pieces[i] != null:
			#Move every cell down 1 space to leave the 1st cell available to be used.
			var new_index = i+1
			holding_pieces[new_index] = holding_pieces[i]
			holding_pieces[new_index].position = holding_locations[new_index] - Vector2(0,4)
	print("     GB Holding_pieces = ", holding_pieces)

func move2_holding_cell(piece_id, start_position):
	all_pieces[piece_id].position = cell_location[start_position]
	var new_position = holding_locations[0] - Vector2(0,4)
	tween = create_tween()
	tween.tween_property(all_pieces[piece_id], "position", new_position, 0.5)
	holding_pieces[0] = all_pieces.pop_at(piece_id)

func update_dino_counter(click_family, texture):
	$Notebook.update_stats(texture, click_family)
	$Notebook.refresh()

func make_dino_holding_cells(count):
	print("== GB Making ", count, " Dino Holding Cell(s) ==")
	for i in range(count):
		var c = cell.instantiate()
		add_child(c)
		holding_cells.append(c)
		holding_pieces.append(null)
		c.id = i

func update_dino_holding_cells():
	var start_position_x : int
	var start_position_y : int = 230
	var cell_num : int = 0
	var cell_size : int = 0
	cell_size = holding_cells[0].get_node("cell").get_rect().size.x
	#Game is setup for a screen width of 1280.
	start_position_x = 980
	print(" GB DHC About to Loop")
	for h : int in range(holding_height):
		#print(" GB DHC Inside H Loop")
		for w : int in range(holding_width):
			#print(" GB DHC Inside W Loop")
			var w_modifier : int = (cell_size + 20) * w
			var h_modifier : int = (cell_size + 12) * h
			holding_cells[cell_num].position = Vector2(start_position_x + w_modifier, start_position_y + h_modifier)
			print(" GB DHC Position #", cell_num, " = ", holding_cells[cell_num].position)
			holding_cells[cell_num].visible = true
			holding_locations.append(holding_cells[cell_num].position)
			cell_num += 1
			#print("Vector = ",w,", ", h)
	print("   dino_holding_Locations = ", holding_locations)

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

func recharge_all():
	$snd_Recharge.play()
	for i in range(max_cells):
		if game_board[i] != Empty:
			if all_pieces[game_board[i]].wait_visible():
				all_pieces[game_board[i]].activate_generator()

func _on_cell_clicked(click, event):
	var is_left_click : bool = false
	var is_1st_click : bool = false
	var is_same_cell : bool = false
	var is_same_texture : bool = false
	var is_same_family : bool = false
	var is_generator : bool = false
	
	var pclick_family : String
	var pclick_texture : int
	var pclick_empty : bool

	var click_family : String
	var click_empty: bool
	var click_texture : int
	var click_generator : String

	var is_dino : bool = false
	var was_pokeball : bool = false
	var was_max : bool = false
	
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
			if pclick_family == "stone" and all_pieces[game_board[previous_click]].max_texture():
				was_max = true
		print("  GB pclick was_max = ", was_max)

	else:
		print("  GB First Click!")
		is_1st_click = true
	
	if click_empty and !pclick_empty and !is_1st_click and previous_click != null and !immobile.has(pclick_family):
		#print("~~~GB ", click, " is Empty and ", previous_click, "is not empty.~~~")
		print("   GB Move to MT Cell")
		place_piece(game_board[previous_click], click, previous_click)

	if !is_1st_click: 
		if !click_empty and !pclick_empty and previous_click != click:
			print("   GB Both cells are occupied AND clicks are NOT the same cell")
		elif previous_click == click:
			is_same_cell = true
			#print("  GB PClick = Click")
			if is_generator and click_family != "fossil":
				$snd_Generate.play()
				#print("  GB ", click_family, " Generating")
				generate_piece(click, click_family)
				var gencount = all_pieces[game_board[click]].decrement_gen_count()
				#print("  GB Generator Direction = ", click_generator)
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
			elif !is_generator and click_family == "heal" and all_pieces[game_board[click]].max_texture():
				#print("  GB is_generator = ", is_generator, "; family = ", click_family, " & max_texture = honey.")
				recharge_all()
				remove_piece(click)
			else:
				#print("  GB is_generator = ", is_generator, "; family = ", click_family)
				if click_family == "crystal" or click_family == "rock":
					print("   GB Crystal OR Rock Clicked Twice!")
					update_score(click)
					remove_piece(click)
		else:
			print("  GB Previous_click @ ", previous_click, " was empty")

	#print(" = GB Click_texture = ", click_texture, " and pclick_texture = ", pclick_texture)
	if click_texture == pclick_texture:
		print("  GB Pieces have the SAME texture")
		is_same_texture = true
	else: 
		print("  GB Pieces have DIFFERENT textures")
		#swap_pieces(cell_id, previous_click)

	#print(" = GB Click_family = ", click_family, " and pclick_family = ", pclick_family)
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

		print("  GB is_dino = ", is_dino, " & was_max = ", was_max)
		if is_dino and was_max:
			if click_texture > 0:
				make_piece(click_family,1,(click_texture-2))
				var mt_cell : int = find_closest_empty_cell(click)
				place_piece((all_pieces.size()-1), mt_cell)
				all_pieces[game_board[click]].decrement_texture()
			else:
				print("  GB pokemon_texture == 0")
			remove_piece(previous_click)

	if !unmergeable.has(click_family) and !is_1st_click and !is_same_cell and is_same_family and is_same_texture and !click_empty:
		print("  GB Mergeable!")
		merge_pieces(click, previous_click)
		update_game_board()
		update_iteminfo(click)
		var FAF : int = find_closest_family(click, "grass", 100)
		#print("  GB Closest Grass is ", FAF)
		if FAF != Empty:
			remove_piece(FAF)
			update_game_board()
			var family : String = find_family(click_family)
			if  family != "error":
				generate_piece(FAF, family)

	if is_left_click:
		previous_click = click
	#print("GB All_pieces = ", all_pieces)
	update_game_board()
	pass # Replace with function body.
	
	auto_generate()

