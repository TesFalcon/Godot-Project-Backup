extends Area2D

signal clicked
signal activate_generator

@export var texture_index = 0
@export var id = 0
@export var family = ""
@export var generator = false

var series = {}

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
"res://pokemerge/fossil08_64.png","res://pokemerge/fossil09_64.png",
"res://pokemerge/fossil10_64.png","res://pokemerge/fossil11_64.png",
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
"res://pokemerge/ruins02_64.png","res://pokemerge/ruins03_64.png",
"res://pokemerge/ruins04_64.png","res://pokemerge/ruins05_64.png",
"res://pokemerge/ruins06_64.png","res://pokemerge/ruins07_64.png",
"res://pokemerge/ruins08_64.png","res://pokemerge/ruins09_64.png",
"res://pokemerge/ruins10_64.png"]

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
	series["drink"] = drink_textures
	series["crystal"] = crystal_textures
	series["vending"] = vending_textures
	series["ruins"] = ruins_textures

	$active.visible = false
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

func increment_texture():
	print("==== GP Incrementing Texture ====")
	print("Family = ", family)
	texture_index += 1
	if texture_index == series[family].size():
		#texture_index above the max for that family.
		texture_index -=1 #Reset to max
	else:
		$pokemart.texture=load(series[family][texture_index])
	if texture_index > 2:
		if family == "pokemart" || family == "ruins": 
		#Only certain families are generators.
			generator = true
			$active.visible = true
			$active.position = to_local(position)
			print("GP Position = ", position)
			print("GP Local position = ", to_local(position))
			print("GP Global position = ", to_global(position))
			activate_generator.emit(id)
	print("===GP Texture = ", texture_index, "===")
	pass # Replace with function body.
