extends Area2D

signal clicked
signal activate_generator

@export var texture_index = 0
@export var id = 0
@export var family = ""
@export var generator = false

var pokemart_textures = ["res://pokemerge/pokemart01_64.png", 
"res://pokemerge/pokemart02_64.png", "res://pokemerge/pokemart03_64.png",
"res://pokemerge/pokemart04_64.png", "res://pokemerge/pokemart05_64.png",
"res://pokemerge/pokemart06_64.png", "res://pokemerge/pokemart07_64.png",
"res://pokemerge/pokemart08_64.png", "res://pokemerge/pokemart09_64.png",
"res://pokemerge/pokemart10_64.png"]

var pokeball_textures = ["res://pokemerge/pokeball01_64.png", 
"res://pokemerge/pokeball02_64.png","res://pokemerge/pokeball03_64.png",
"res://pokemerge/pokeball04_64.png","res://pokemerge/pokeball05_64.png",
"res://pokemerge/pokeball06_64.png","res://pokemerge/pokeball07_64.png"]

var heal_textures = ["res://pokemerge/heal01_64.png", 
"res://pokemerge/heal02_64.png","res://pokemerge/heal03_64.png",
"res://pokemerge/heal04_64.png","res://pokemerge/heal05_64.png"]

var series = [pokemart_textures, pokeball_textures, heal_textures]

var dragging = false
var click_radius = 32 # Size of the sprite.

#var m_grid_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
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
	var which_series
	print("Family = ", family)
	match family:
		"pokemart":
			which_series = 0
		"pokeball":
			which_series = 1
		"heal":
			which_series = 2
	texture_index += 1
	$pokemart.texture=load(series[which_series][texture_index])
	if texture_index > 2 and which_series == 0: 
		#Only certain families are generators.
		generator = true
		$active.visible = true
		#$active.position = position
		print("GP Position = ", position)
		print("GP Local position = ", to_local(position))
		print("GP Global position = ", to_global(position))
		activate_generator.emit(id)
	print("===GP Texture = ", texture_index, "===")
	pass # Replace with function body.
