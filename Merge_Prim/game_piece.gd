extends Area2D

signal clicked

@export var texture_index : int = 0
@export var id : int = 0
@export var family : String = ""
@export var generator : String = ""
@export var generator_count : int = -1

var series : Dictionary = {}
var item_info : Dictionary = {}

var tween : Tween

const pokemart_textures := ["res://pokemerge/pokemart01_64.png",
"res://pokemerge/pokemart02_64.png", "res://pokemerge/pokemart03_64.png",
"res://pokemerge/pokemart04_64.png", "res://pokemerge/pokemart05_64.png",
"res://pokemerge/pokemart06_64.png", "res://pokemerge/pokemart07_64.png",
"res://pokemerge/pokemart08_64.png", "res://pokemerge/pokemart09_64.png",
"res://pokemerge/pokemart10_64.png"]

const pokeball_textures := ["res://pokemerge/pokeball01_64.png",
"res://pokemerge/pokeball02_64.png","res://pokemerge/pokeball03_64.png",
"res://pokemerge/pokeball04_64.png","res://pokemerge/pokeball05_64.png",
"res://pokemerge/pokeball06_64.png","res://pokemerge/pokeball07_64.png",
"res://pokemerge/pokeball08_64.png","res://pokemerge/pokeball09_64.png",
"res://pokemerge/pokeball10_64.png"]

const heal_textures := ["res://pokemerge/heal01_64.png",
"res://pokemerge/heal02_64.png","res://pokemerge/heal03_64.png",
"res://pokemerge/heal04_64.png","res://pokemerge/heal05_64.png"]

const fossil_textures := ["res://pokemerge/fossil01_64.png",
"res://pokemerge/fossil02_64.png","res://pokemerge/fossil03_64.png",
"res://pokemerge/fossil04_64.png","res://pokemerge/fossil05_64.png",
"res://pokemerge/fossil06_64.png","res://pokemerge/fossil12_64.png"]

const stone_textures := ["res://pokemerge/stone01_64.png",
"res://pokemerge/stone02_64.png","res://pokemerge/stone03_64.png",
"res://pokemerge/stone04_64.png","res://pokemerge/stone05_64.png",
"res://pokemerge/stone06_64.png"]

const crystal_textures := ["res://pokemerge/crystal01_64.png",
"res://pokemerge/crystal02_64.png","res://pokemerge/crystal03_64.png",
"res://pokemerge/crystal04_64.png","res://pokemerge/crystal05_64.png"]

const ruins_textures := ["res://pokemerge/ruins01_64.png",
"res://pokemerge/ruins02_64.png","res://pokemerge/ruins03_64.png", #Yes, ruins04 is skipped.
"res://pokemerge/ruins05_64.png", "res://pokemerge/ruins06_64.png",
"res://pokemerge/ruins07_64.png", "res://pokemerge/ruins08_64.png",
"res://pokemerge/ruins09_64.png", "res://pokemerge/ruins10_64.png"]

const chest_textures := ["res://pokemerge/gift01_64.png",
"res://pokemerge/gift02_64.png","res://pokemerge/gift03_64.png",
"res://pokemerge/gift04_64.png", "res://pokemerge/gift05_64.png"]

const grass_textures := ["res://pokemerge/grass01_64.png",
"res://pokemerge/grass02_64.png","res://pokemerge/grass03_64.png"]

const bulbasaur_textures := ["res://pokemerge/bulbasaur01_64.png",
"res://pokemerge/bulbasaur02_64.png","res://pokemerge/bulbasaur03_64.png",
"res://pokemerge/bulbasaur04_64.png"]

const charmander_textures := ["res://pokemerge/charmander01_64.png",
"res://pokemerge/charmander02_64.png","res://pokemerge/charmander03_64.png",
"res://pokemerge/charmander04_64.png", "res://pokemerge/charmander05_64.png"]

const squirtle_textures := ["res://pokemerge/squirtle1_64.png",
"res://pokemerge/squirtle2_64.png","res://pokemerge/squirtle3_64.png",
"res://pokemerge/squirtle4_64.png"]

const game_textures := ["res://pokemerge/game01_64.png",
"res://pokemerge/game02_64.png","res://pokemerge/game03_64.png",
"res://pokemerge/game04_64.png","res://pokemerge/game05_64.png",
"res://pokemerge/game06_64.png","res://pokemerge/game07_64.png",
"res://pokemerge/game08_64.png","res://pokemerge/game09_64.png"]

const legendary_textures := ["res://pokemerge/legendary03_64.png",
"res://pokemerge/legendary04_64.png","res://pokemerge/legendary05_64.png",
"res://pokemerge/legendary06_64.png","res://pokemerge/legendary07_64.png",
"res://pokemerge/legendary08_64.png","res://pokemerge/legendary09_64.png",
"res://pokemerge/legendary10_64.png","res://pokemerge/legendary11_64.png"]

const rock_textures := ["res://pokemerge/rock01_64.png",
"res://pokemerge/rock02_64.png","res://pokemerge/rock03_64.png",
"res://pokemerge/rock04_64.png"]

const generators := ["pokemart", "ruins", "game"] # "industry",
const reverse_generators := ["chest", "fossil"] # "vending",
const dino := ["bulbasaur", "squirtle", "charmander", "legendary"]

var dragging : bool = false
var click_radius : int = 32 # Size of the sprite.

#var m_grid_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	series["game"] = game_textures
	series["ruins"] = ruins_textures
	series["fossil"] = fossil_textures
	series["stone"] = stone_textures
	series["crystal"] = crystal_textures
	series["chest"] = chest_textures
	series["pokemart"] = pokemart_textures
	series["pokeball"] = pokeball_textures
	series["heal"] = heal_textures
	series["grass"] = grass_textures
	series["bulbasaur"] = bulbasaur_textures
	series["squirtle"] = squirtle_textures
	series["charmander"] = charmander_textures
	series["legendary"] = legendary_textures
	series["rock"] = rock_textures
	#series["industry"] = industry_textures
	#series["vending"] = vending_textures
	#series["drink"] = drink_textures
	
	item_info["grass"] = "[b]What's hiding in the grass?[/b]"
	item_info["game"] = "[b]Pokemon is just a game. Isn't it?[/b]"
	item_info["fossil"] = "[b]Ancient Pokemon Fossils[/b]"
	item_info["stone"] = "[b]Precious Stones[/b]"
	item_info["pokemart"] = "[b]Generates Pokeballs[/b]"
	item_info["pokeball"] = "[b]Pokeball[/b]"
	item_info["heal"] = "[b]Healing Lotions[/b]"
	item_info["crystal"] = "[b]Click to collect eXperience Points[/b]"
	item_info["ruins"] = "[b]Generates fossils[/b]"
	item_info["chest"] = "[b]Click to get generation material[/b]"
	item_info["rock"] = "[b]Click to collect Bonus Xperience Points[/b]"
	item_info["bulbasaur"] = "[b]Is it a Bulbasaur or a Cabbage Patch Monster?[/b]"
	item_info["squirtle"] = "[b]Squirtle looks innocent, doesn't he?[/b]"
	item_info["charmander"] = "[b]Is Charmander the inspiration for the firebreathing dragon?[/b]"
	item_info["legendary"] = "[b]Pokemon from long ago still inspire awe and fear.[/b]"
	#item_info["industry"] = "[b]Generates vending machines[/b]"
	#item_info["vending"] = "[b]Generates drinks[/b]"
	#item_info["drink"] = "[b]Quenches your thirst[/b]"

	$active.visible = false
	$wait.visible = false
	$max.visible = false
	#$pokemart.texture = load(pokemart_textures[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _input(event):
	if event.is_action_released("left_mouse_click"):
		#print("GP Left Mouse Released")
		pass
	elif event.is_action_pressed("left_mouse_click"):
		#print("GP Left Mouse Clicked")
		#increment_texture(my_name)
		clicked.emit(id, event)

func max_texture() -> bool:
	if family != null:
		#print(" GP family_size = ", series[family].size())
		if texture_index == series[family].size() - 1:
			#texture_index at the max for that family.
			if family != "grass":
				if !$max.visible:
					$max.visible = true
					$max.position = to_local(position) + Vector2(0,30)
					$max.scale = Vector2(0.75, 0.75)
			return true
	return false

func activate_generator():
	print("= GP Activate_Generator = ")
	$snd_Activate.play()
	#Hide the wait stopwatch if it was visible
	$wait.visible = false
	
	# Place active bolt over the image.
	$active.position = to_local(position)
	#Nudge it into a better position v---v
	$active.position = $active.position + Vector2(25,25)
	$active.visible = true

	# Set generator_count tracks how many times the generator has made pieces
	if generators.has(family):
		#print(" ~~~ GP Generator Count set")
		generator_count = (texture_index-2) * 10
	elif reverse_generators.has(family):
		#print(" ~~~ GP Rev_Generator Count set")
		generator_count = 5
	else:
		print("  GP NOT Generator & NOT Reverse Generator. Family = ", family)

	throb()

func deactivate_generator():
	#print("= GP Deactivate_Generator = ")
	# Remove active bolt.
	$active.visible = false
	# Place wait stopwatch over the image.
	$wait.position = to_local(position)
	#Nudge it into a better position v---v
	$wait.position = $active.position + Vector2(15,15)
	$wait.visible = true
	stop_throbbing()
	
func increment_texture() -> bool:
	print("== GP Incrementing Texture ==")
	#print(" GP Family = ", family)
	var is_max_texture : bool = max_texture()
	var is_texture_incremented : bool = false
	if !is_max_texture:
		texture_index += 1
		is_max_texture = max_texture()
		is_texture_incremented = true
		
	if generators.has(family) and texture_index > 2:
		activate_generator()
	if reverse_generators.has(family) and is_max_texture:
		activate_generator()
	$pokemart.texture=load(series[family][texture_index])
	#print(" GP Texture_Incremented")
	#print(" GP Texture = ", texture_index)
	#print(" GP Texture_size = ", series[family].size(), "===")
	return is_texture_incremented

func decrement_texture() -> bool :
	print(" = GP Decrementing Texture = ")
	texture_index -= 1
	if texture_index > -1:
		$pokemart.texture=load(series[family][texture_index])
	#print("GP Texture_index = ", texture_index)
	return texture_index

func decrement_gen_count() -> int:
	generator_count -= 1
	return generator_count

func get_iteminfo() -> String:
	var item_text : String = item_info[family]
	if family != "grass":
		if family == "crystal":
			var curr_crystal_value = get_parent().calculate_score(texture_index)
			var next_crystal_value = get_parent().calculate_score(texture_index+1)
			item_text += "[p]Click to collect " + str(curr_crystal_value) + " points or merge to collect " + str(next_crystal_value) + " points.[/p]"
		if !max_texture():
			item_text += "[p] Merge two lvl " + str(texture_index+1) + ": [img]" + series[family][texture_index] + "[/img]"
			item_text += " ==> lvl " + str(texture_index+2) + ": [img]" + series[family][texture_index+1] + "[/img] [/p]"
		else:
			item_text += "[p][center]At Maximum Merge Level[/center][/p]"
			if family == "heal":
				item_text+= "[p][center]Click again to reset your generators.[/center][/p]"
			if family == "stone":
				item_text+= "[p][center]Merge w Pokemon to split into 2 lesser Pokemon.[/center][/p]"
	return "[center]" + item_text + "[/center]"

func throb():
	tween = create_tween()	
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	var duration : float = 1.5
	tween.tween_property($pokemart, "scale", Vector2(0.8,0.8), duration)
	tween.tween_property($pokemart, "scale", Vector2(0.9,0.9), duration)


func stop_throbbing():
	if tween != null:
		tween.kill()

func family_tree(fam) -> String:
	var tree : String = ""
	if fam != "grass":
		for i in range(series[fam].size()):
			var level : int = i+1
			var img : String = get_img(fam,i)
			tree += "[p]Level " + str(level) + ": " + str(img) + "[/p]"
	return tree

func generator_tree() -> String:
	var gen_tree : String = "Generators Produce ..."
	var gen_img : int = 3
	for i in range(generators.size()):
		var img : String = get_img(generators[i],gen_img)
		var next_fam = get_parent().find_family(generators[i])
		var next_img : String = get_img(next_fam,0)

		gen_tree += "[p]"+ generators[i] +" => " + next_fam + "[/p]"
		gen_tree += "[p]" + str(img) + " => " + str(next_img) + "[/p]"

	for i in range(reverse_generators.size()):
		gen_img = series[reverse_generators[i]].size()-1
		var img : String = get_img(reverse_generators[i],gen_img)
		var next_fam = get_parent().find_family(reverse_generators[i])
		if next_fam == "fossil":
			next_fam = "bulbasaur"
		var next_img : String = get_img(next_fam,0)

		gen_tree += "[p]"+ reverse_generators[i] +" => " + next_fam + "[/p]"
		gen_tree += "[p]" + str(img) + " => " + str(next_img) + "[/p]"
	return gen_tree

func capture_tree() -> String:
	var cap_tree : String = "[p] pokeball => dino[/p]"
	for i in range(dino.size()):
		for j in range(series[dino[i]].size()):
			if dino[i] == "bulbasaur":
				cap_tree += "[p]" + get_img("pokeball",j+1) + " => " + get_img(dino[i],j) + "[/p]"
			if dino[i] == "squirtle":
				cap_tree += "[p]" + get_img("pokeball",j+2) + " => " + get_img(dino[i],j) + "[/p]"
			if dino[i] == "charmander":
				cap_tree += "[p]" + get_img("pokeball",j+3) + " => " + get_img(dino[i],j) + "[/p]"
			if dino[i] == "legendary":
				cap_tree += "[p]" + get_img("pokeball",j) + " => " + get_img(dino[i],j) + "[/p]"
	return "[center]" + cap_tree + "[/center]"

func init_stats(fam) -> Dictionary:
	var stats : Dictionary = {}
	for i in range(series[fam].size()):
		stats[i] = 0
	return stats

func get_img(fam, index) -> String:
	return "[img]" + series[fam][index] + "[/img]"

func wait_visible() -> bool:
	return $wait.visible
