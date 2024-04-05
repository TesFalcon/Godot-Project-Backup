extends Sprite2D

var pokemerge_page : String = "[p][center][b]Welcome to PokeMerge![/b][/center][/p]			[p]In the world of Pokemon, it's easy to think of it as just a game, but it's so much more. Here we will explore the fossil evidence of ancient dinosaurs, the commercialization of pokemon capture, and ask the all-important question ...[/p] [p][center][b][i]CAN YOU CATCH 'EM ALL?[/i][/b][/center][/p]			[p]To learn more, click the Arrows below.[/p]			[p]To mirror a page to the right side of the screen, click the Notebook.[/p]"
var game_page : String = "[p][center]It's Just a Game[/center][/p]"
var ruins_page : String = "[center][p]What's In These Ruins[/p][/center]"
var fossil_page : String = "[center][p]I Found a Fossil![/p][/center]"
var pokemart_page : String = "[center][p]The World of Pokemart[/p][/center]"
var pokeball_page : String = "[center][p]Pokeballs in All Their Variety[/p][/center]"
var heal_page : String = "[center][p]Healing Salves and Lotions[/p][/center]"
var stone_page : String = "[center][p]Precious Stones[/p][/center]"
var crystal_page : String = "[center][p]Experience Point Crystals[/p][/center]"
var rock_page : String = "[center][p]Super XP with Special Rocks[/p][/center]"
var bulbasaur_page : String = "[center][p]Bulbasaur[/p][/center]"
var squirtle_page : String = "[center][p]Squirtle[/p][/center]"
var charmander_page : String = "[center][p]Charmander[/p][/center]"
var legendary_page : String = "[center][p]Legendary Pokemon[/p][/center]"

var Notebook : Dictionary = {}
var bulb_stats : Dictionary = {}
var squirtle_stats : Dictionary = {}
var char_stats : Dictionary = {}
var legend_stats : Dictionary = {}

var page := []
var current_page : int = -1

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
	
	next_page()

func _input(event):
	if event.is_action_pressed("left_mouse_click"):
		if get_rect().has_point(to_local(event.position)):
			print("Notebook Left Mouse Clicked")
			mirror_to_lblStatic()
	pass

func next_page():
	current_page += 1
	if current_page >= Notebook.size():
		current_page = 0 
	get_parent().get_node("Control/lblInstructions").text = Notebook[page[current_page]]

func previous_page():
	current_page -= 1
	if current_page < 0:
		current_page = Notebook.size()-1 
	get_parent().get_node("Control/lblInstructions").text = Notebook[page[current_page]]

func get_family_tree(family) -> String:
	return get_parent().get_node("GamePiece").family_tree(family)

func get_generator_tree() -> String:
	return get_parent().get_node("GamePiece").generator_tree()

func get_capture_tree() -> String:
	var cap_tree : String = "[p][b] Catch Pokemon Like This [/b][/p]"
	cap_tree += get_parent().get_node("GamePiece").capture_tree()
	return cap_tree

func get_stats() -> String:
	var stats : String = "[p]Pokemon Captured![/p]"
	for i : int in bulb_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("bulbasaur",i) +  " = " + str(bulb_stats[i]) + "[/p]"
	for i : int in squirtle_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("squirtle",i) +  " = " + str(squirtle_stats[i]) + "[/p]"
	for i : int in char_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("charmander",i) +  " = " + str(char_stats[i]) + "[/p]"
	for i : int in legend_stats.size():
		stats += "[p] " + get_parent().get_node("GamePiece").get_img("legendary",i) +  " = " + str(legend_stats[i]) + "[/p]"
	return "[center]" + stats + "[/center]"

func update_stats(tex_index, fam):
	match fam:
		"bulbasaur":
			bulb_stats[tex_index] += 1
		"squirtle":
			squirtle_stats[tex_index] += 1
		"charmander":
			char_stats[tex_index] += 1
		"legendary":
			legend_stats[tex_index] += 1
	Notebook["stats"] = get_stats()

func mirror_to_lblStatic():
	get_parent().get_node("Control/lblStatic").text = Notebook[page[current_page]]

func refresh():
	get_parent().get_node("Control/lblInstructions").text = Notebook[page[current_page]]

func is_max_texture(fam, tex_index) -> bool:
	match fam:
		"bulbasaur":
			if tex_index == bulb_stats.size():
				return true
		"squirtle":
			if tex_index == squirtle_stats.size():
				return true
		"charmander":
			if tex_index == char_stats.size():
				return true
		"legendary":
			if tex_index == legend_stats.size():
				return true
	return false
