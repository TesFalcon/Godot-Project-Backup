extends Sprite2D

var pokemerge_page = "[center][p]Welcome to PokeMerge![/p][/center]
			[p]In the world of Pokemon, it's easy to think of it as just a game, but it's so much more. Here we will explore the fossil evidence of ancient dinosaurs, the commercialization of pokemon capture, and ask the all-important question ...[/p] [p][b][i]CAN YOU CATCH 'EM ALL?[/i][/b][/p]
			[p]To learn more, click the Notebook below.[/p]"
var game_page = "[center][p]It's Just a Game[/p][/center]"
var ruins_page = "[center][p]What's In These Ruins[/p][/center]"
var fossil_page = "[center][p]I Found a Fossil![/p][/center]"
var pokemart_page = "[center][p]The World of Pokemart[/p][/center]"
var pokeball_page = "[center][p]Pokeballs in All Their Variety[/p][/center]"
var heal_page = "[center][p]Healing Salves and Lotions[/p][/center]"
var stone_page = "[center][p]Precious Stones[/p][/center]"
var crystal_page = "[center][p]Experience Point Crystals[/p][/center]"
var industry_page = "[center][p]Industrialization of Modern Life[/p][/center]"
var vending_page = "[center][p]Vending Machines are Everywhere[/p][/center]"
var drink_page = "[center][p]Thirsty? Get a drink![/p][/center]"
var rock_page = "[center][p]Super XP with Special Rocks[/p][/center]"
var bulbasaur_page = "[center][p]Bulbasaur[/p][/center]"
var squirtle_page = "[center][p]Squirtle[/p][/center]"
var charmander_page = "[center][p]Charmander[/p][/center]"
var legendary_page = "[center][p]Legendary Pokemon[/p][/center]"

var Notebook = {}
var bulb_stats = {}
var squirtle_stats = {}
var char_stats = {}
var legend_stats = {}

var page = []
var current_page = -1
var game_piece = preload("res://game_piece.tscn")
var game_piece_family = []
# Called when the node enters the scene tree for the first time.
func _ready():
	page.append("pokemerge")
	Notebook["pokemerge"] = pokemerge_page
	page.append("generator")
	Notebook["generator"] = get_generator_tree()
	page.append("capture")
	Notebook["capture"] = get_capture_tree()
	page.append("game")
	Notebook["game"] = game_page + get_family_tree("game")
	page.append("ruins")
	Notebook["ruins"] = ruins_page + get_family_tree("ruins")
	page.append("fossil")
	Notebook["fossil"] = fossil_page + get_family_tree("fossil")
	page.append("stone")
	Notebook["stone"] = stone_page + get_family_tree("stone")
	page.append("crystal")
	Notebook["crystal"] = crystal_page + get_family_tree("crystal")
	page.append("pokemart")
	Notebook["pokemart"] = pokemart_page + get_family_tree("pokemart")
	page.append("pokeball")
	Notebook["pokeball"] = pokeball_page + get_family_tree("pokeball")
	page.append("heal")
	Notebook["heal"] = heal_page + get_family_tree("heal")
	#page = industry_page + get_family_tree("industry")
	#Notebook.append(page)
	#page = vending_page + get_family_tree("vending")
	#Notebook.append(page)
	#page = drink_page + get_family_tree("drink")
	#Notebook.append(page)
	page.append("rock")
	Notebook["rock"] = rock_page + get_family_tree("rock")
	page.append("bulbasaur")
	Notebook["bulbasaur"] = bulbasaur_page + get_family_tree("bulbasaur")
	page.append("squirtle")
	Notebook["squirtle"] = squirtle_page + get_family_tree("squirtle")
	page.append("charmander")
	Notebook["charmander"] = charmander_page + get_family_tree("charmander")
	page.append("legendary")
	Notebook["legendary"] = legendary_page + get_family_tree("legendary")
	
	bulb_stats = get_parent().get_node("GamePiece").init_stats("bulbasaur")
	squirtle_stats = get_parent().get_node("GamePiece").init_stats("squirtle")
	char_stats = get_parent().get_node("GamePiece").init_stats("charmander")
	legend_stats = get_parent().get_node("GamePiece").init_stats("legendary")

	page.append("stats")
	Notebook["stats"] = get_stats()
	
	current_page += 1
	next_page()
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("left_mouse_click"):
		if get_rect().has_point(to_local(event.position)):
			print("Notebook Left Mouse Clicked")
			current_page += 1
			next_page()
	pass

func next_page():
	if current_page >= Notebook.size():
		current_page = 0 
	get_parent().get_node("Control/lblInstructions").bbcode_enabled = true
	get_parent().get_node("Control/lblInstructions").text = Notebook[page[current_page]]

func get_family_tree(family):
	return get_parent().get_node("GamePiece").family_tree(family)

func get_generator_tree():	
	return get_parent().get_node("GamePiece").generator_tree()

func get_capture_tree():
	var cap_tree = "[p][b] Catch Pokemon Like This [/b][/p]"
	cap_tree += get_parent().get_node("GamePiece").capture_tree()
	return cap_tree

func get_stats():
	var stats = "[p]Pokemon Captured![/p]"
	for i in bulb_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("bulbasaur",i) +  " = " + str(bulb_stats[i]) + "[/p]"
	for i in squirtle_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("squirtle",i) +  " = " + str(squirtle_stats[i]) + "[/p]"
	for i in char_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("charmander",i) +  " = " + str(char_stats[i]) + "[/p]"
	for i in legend_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("legendary",i) +  " = " + str(legend_stats[i]) + "[/p]"
	return "[center]" + stats + "[/center]"

func update_stats(texture, fam):
	match fam:
		"bulbasaur":
			bulb_stats[texture] += 1
		"squirtle":
			squirtle_stats[texture] += 1
		"charmander":
			char_stats[texture] += 1
		"legendary":
			legend_stats[texture] += 1
	Notebook["stats"] = get_stats()
