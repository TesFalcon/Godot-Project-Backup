extends Area2D

signal clicked

@export var texture_index = 0
@export var id = 0
@export var family = ""
@export var generator = ""
@export var gen_count = -1

var series = {}
var item_info = {}

const pokemart_textures = ["res://pokemerge/pokemart01_64.png", 
"res://pokemerge/pokemart02_64.png", "res://pokemerge/pokemart03_64.png",
"res://pokemerge/pokemart04_64.png", "res://pokemerge/pokemart05_64.png",
"res://pokemerge/pokemart06_64.png", "res://pokemerge/pokemart07_64.png",
"res://pokemerge/pokemart08_64.png", "res://pokemerge/pokemart09_64.png",
"res://pokemerge/pokemart10_64.png"]

const pokeball_textures = ["res://pokemerge/pokeball01_64.png", 
"res://pokemerge/pokeball02_64.png","res://pokemerge/pokeball03_64.png",
"res://pokemerge/pokeball04_64.png","res://pokemerge/pokeball05_64.png",
"res://pokemerge/pokeball06_64.png","res://pokemerge/pokeball07_64.png"]

const heal_textures = ["res://pokemerge/heal01_64.png", 
"res://pokemerge/heal02_64.png","res://pokemerge/heal03_64.png",
"res://pokemerge/heal04_64.png","res://pokemerge/heal05_64.png"]

const fossil_textures = ["res://pokemerge/fossil01_64.png", 
"res://pokemerge/fossil02_64.png","res://pokemerge/fossil03_64.png",
"res://pokemerge/fossil04_64.png","res://pokemerge/fossil05_64.png",
"res://pokemerge/fossil06_64.png","res://pokemerge/fossil07_64.png",
"res://pokemerge/fossil12_64.png"]

const stone_textures = ["res://pokemerge/stone01_64.png", 
"res://pokemerge/stone02_64.png","res://pokemerge/stone03_64.png",
"res://pokemerge/stone04_64.png","res://pokemerge/stone05_64.png",
"res://pokemerge/stone06_64.png","res://pokemerge/stone07_64.png",
"res://pokemerge/stone08_64.png","res://pokemerge/stone09_64.png",
"res://pokemerge/stone10_64.png"]

const drink_textures = ["res://pokemerge/drink01_64.png", 
"res://pokemerge/drink02_64.png","res://pokemerge/drink03_64.png",
"res://pokemerge/drink04_64.png","res://pokemerge/drink05_64.png",
"res://pokemerge/drink06_64.png","res://pokemerge/drink07_64.png"]

const crystal_textures = ["res://pokemerge/crystal01_64.png", 
"res://pokemerge/crystal02_64.png","res://pokemerge/crystal03_64.png",
"res://pokemerge/crystal04_64.png","res://pokemerge/crystal05_64.png"]

const industry_textures = ["res://pokemerge/industry01_64.png", 
"res://pokemerge/industry02_64.png","res://pokemerge/industry03_64.png",
"res://pokemerge/industry04_64.png","res://pokemerge/industry05_64.png",
"res://pokemerge/industry07_64.png","res://pokemerge/industry07_64.png",
"res://pokemerge/industry08_64.png","res://pokemerge/industry09_64.png"]

const vending_textures = ["res://pokemerge/vending01_64.png", 
"res://pokemerge/vending02_64.png","res://pokemerge/vending03_64.png"]

const ruins_textures = ["res://pokemerge/ruins01_64.png", 
"res://pokemerge/ruins02_64.png","res://pokemerge/ruins03_64.png", #Yes, ruins04 is skipped.
"res://pokemerge/ruins05_64.png", "res://pokemerge/ruins06_64.png",
"res://pokemerge/ruins07_64.png", "res://pokemerge/ruins08_64.png",
"res://pokemerge/ruins09_64.png", "res://pokemerge/ruins10_64.png"]

const chest_textures = ["res://pokemerge/gift01_64.png", 
"res://pokemerge/gift02_64.png","res://pokemerge/gift03_64.png",
"res://pokemerge/gift04_64.png", "res://pokemerge/gift05_64.png"]

const grass_textures = ["res://pokemerge/grass01_64.png", 
"res://pokemerge/grass02_64.png","res://pokemerge/grass03_64.png"]

const bulbasaur_textures = ["res://pokemerge/bulbasaur01_64.png", 
"res://pokemerge/bulbasaur02_64.png","res://pokemerge/bulbasaur03_64.png",
"res://pokemerge/bulbasaur04_64.png"]

const charmander_textures = ["res://pokemerge/charmander01_64.png", 
"res://pokemerge/charmander02_64.png","res://pokemerge/charmander03_64.png",
"res://pokemerge/charmander04_64.png", "res://pokemerge/charmander05_64.png"]

const squirtle_textures = ["res://pokemerge/squirtle01_64.png", 
"res://pokemerge/squirtle02_64.png","res://pokemerge/squirtle03_64.png",
"res://pokemerge/squirtle04_64.png"]

const game_textures = ["res://pokemerge/game01_64.png", 
"res://pokemerge/game02_64.png","res://pokemerge/game03_64.png",
"res://pokemerge/game04_64.png","res://pokemerge/game05_64.png",
"res://pokemerge/game06_64.png","res://pokemerge/game07_64.png",
"res://pokemerge/game08_64.png","res://pokemerge/game09_64.png"]

const legendary_textures = ["res://pokemerge/legendary01_64.png", 
"res://pokemerge/legendary02_64.png","res://pokemerge/legendary03_64.png",
"res://pokemerge/legendary04_64.png","res://pokemerge/legendary05_64.png",
"res://pokemerge/legendary06_64.png","res://pokemerge/legendary07_64.png",
"res://pokemerge/legendary08_64.png","res://pokemerge/legendary09_64.png",
"res://pokemerge/legendary10_64.png","res://pokemerge/legendary11_64.png"]

const rock_textures = ["res://pokemerge/rock01_64.png", 
"res://pokemerge/rock02_64.png","res://pokemerge/rock03_64.png",
"res://pokemerge/rock04_64.png"]

const generators = ["pokemart", "ruins", "industry", "game"]
const reverse_generators = ["chest", "vending"]

var generator_counts = {}
	
var dragging = false
var click_radius = 32 # Size of the sprite.

#var m_grid_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	series["pokemart"] = pokemart_textures
	series["pokeball"] = pokeball_textures
	series["heal"] = heal_textures
	series["fossil"] = fossil_textures
	series["stone"] = stone_textures
	series["crystal"] = crystal_textures
	series["ruins"] = ruins_textures
	series["chest"] = chest_textures
	series["industry"] = industry_textures
	series["vending"] = vending_textures
	series["drink"] = drink_textures
	series["grass"] = grass_textures
	series["squirtle"] = squirtle_textures
	series["rock"] = rock_textures
	series["legendary"] = legendary_textures
	series["game"] = game_textures
	series["charmander"] = charmander_textures
	series["bulbasaur"] = bulbasaur_textures
		
	item_info["pokemart"] = "[b]Generates Pokeballs[/b]"
	item_info["pokeball"] = "[b]Pokeball[/b]"
	item_info["heal"] = "[b]Heals you[/b]"
	item_info["fossil"] = "[b]Fossils of ancient Pokemon[/b]"
	item_info["stone"] = "[b]Stones[/b]"
	item_info["crystal"] = "[b]Click to collect Xperience Points[/b]"
	item_info["ruins"] = "[b]Generates fossils[/b]"
	item_info["chest"] = "[b]Click to get generation material[/b]"
	item_info["industry"] = "[b]Generates vending machines[/b]"
	item_info["vending"] = "[b]Generates drinks[/b]"
	item_info["drink"] = "[b]Quenches your thirst[/b]"
	item_info["grass"] = "[b]What's hiding in the grass?[/b]"
	item_info["rock"] = "[b]Click to collect Bonus Xperience Points[/b]"
	item_info["game"] = "[b]Pokemon is just a game. Isn't it?[/b]"
	item_info["legendary"] = "[b]Pokemon from long ago still inspire awe and fear.[/b]"
	item_info["squirtle"] = "[b]Squirtle looks innocent, doesn't he?[/b]"
	item_info["charmander"] = "[b]Is Charmander the inspiration for the firebreathing dragon?[/b]"
	item_info["bulbasaur"] = "[b]Is it a Bulbasaur or a Cabbage Patch Monster?[/b]"

	for i in range(generators.size()):
		generator_counts[generators[i]] = 30
	for i in range(reverse_generators.size()):
		generator_counts[reverse_generators[i]] = 6
	
	$active.visible = false
	$wait.visible = false
	#$pokemart.texture = load(pokemart_textures[0])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	
	# This code for drag n drop stopped working in the new setup.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - $pokemart.position).length() < click_radius:
			# Start dragging if the click is on the sprite.
			if not dragging and event.pressed:
				dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false
		if event is InputEventMouseMotion and dragging:
			# While dragging, move the sprite with the mouse.
			$pokemart.position = to_local(event.position)

	if event.is_action_released("left_mouse_click"):
		#print("GP Left Mouse Released")
		pass
	elif event.is_action_pressed("left_mouse_click"):
		#print("GP Left Mouse Clicked")
		#increment_texture(my_name)
		clicked.emit(id, event)

func max_texture():
	if family != null:
		print(" GP family_size = ", series[family].size())
		if texture_index == series[family].size() - 1:
			#texture_index at the max for that family.
			return true
		else:
			return false

func activate_generator():
	print("= GP Activate_Generator = ")
	#Hide the wait stopwatch if it was visible
	$wait.visible = false

	# Place active bolt over the image.
	$active.position = to_local(position)
	#Nudge it into a better position v---v
	$active.position = $active.position + Vector2(25,25)
	$active.visible = true
	
	# Set gen_count to track how many times the generator has made pieces
	gen_count = generator_counts[family]
	
func deactivate_generator():
	print("= GP Deactivate_Generator = ")
	# Remove active bolt.
	$active.visible = false
	# Place wait stopwatch over the image.
	$wait.position = to_local(position)
	#Nudge it into a better position v---v
	$wait.position = $active.position + Vector2(15,15)
	$wait.visible = true
	
func increment_texture():
	print("== GP Incrementing Texture ==")
	print(" GP Family = ", family)
	var is_max_texture = max_texture()
	var is_texture_incremented = false
	if !is_max_texture:
		texture_index += 1
		is_max_texture = max_texture()
		is_texture_incremented = true
		
	if generators.has(family) and texture_index > 2:
		activate_generator()
	if reverse_generators.has(family) and is_max_texture:
		activate_generator()
	$pokemart.texture=load(series[family][texture_index])
	print(" GP Texture_Incremented")
	print(" GP Texture = ", texture_index)
	#print(" GP Texture_size = ", series[family].size(), "===")
	return is_texture_incremented

func decrement_texture():
	texture_index -= 1
	if texture_index > -1:
		$pokemart.texture=load(series[family][texture_index])
	print("GP Texture_index = ", texture_index)
	return texture_index

func decrement_gen_count():
	gen_count -= 1
	return gen_count

func get_iteminfo():
	var item_text = item_info[family]
	if family != "grass":
		var curr_img = "[img]" + series[family][texture_index] + "[/img]"
		var next_image
		if !max_texture():
			next_image = "[img]" + series[family][texture_index+1] + "[/img]"
		else:
			next_image = curr_img
		item_text = item_text + "[p] Merge two lvl " + str(texture_index+1) + ": " + curr_img + " ==> lvl " + str(texture_index+2) + ": " +  next_image + "[/p]"
	return "[center]" + item_text + "[/center]"
