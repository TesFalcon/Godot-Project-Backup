extends Area2D

signal clicked

@export var texture_index = 0
@export var my_name = ""

var pokemart_textures = ["res://pokemerge/pokemart01.png", 
"res://pokemerge/pokemart02a.png", "res://pokemerge/pokemart03.png",
"res://pokemerge/pokemart04.png", "res://pokemerge/pokemart05.png",
"res://pokemerge/pokemart06.png", "res://pokemerge/pokemart07.png",
"res://pokemerge/pokemart08.png", "res://pokemerge/pokemart09.png",
"res://pokemerge/pokemart10.png"]

var dragging = false
var click_radius = 32 # Size of the sprite.

var m_grid_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$pokemart.position = Vector2(100,100)
	if input_pickable:
		#print("GP Is Pickable")
		pass
	else:
		set_pickable(true)
	$pokemart.texture = load(pokemart_textures[0])
	#print ("$pokemart.size = ", $pokemart.get_rect().size)
	m_grid_size = $pokemart.get_rect().size / 4
	#print ("m_grid_size = ", m_grid_size)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Snap - To - Grid
	# divide mouse position by grid size, 
	# use floorf to disard decimal
	# then multiply by grid size
	var _v_x : float = floorf(get_global_mouse_position().x / m_grid_size.x) * m_grid_size.x
	var _v_y : float = floorf(get_global_mouse_position().y / m_grid_size.y) * m_grid_size.y
	#set global position
	#global_position = Vector2(v_x, v_y);	

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
		clicked.emit(my_name, event)

func increment_texture():
	print("GP Incrementing Texture")
	texture_index += 1
	if texture_index > pokemart_textures.size() - 1:
		texture_index = 0
	$pokemart.texture=load(pokemart_textures[texture_index])
	#print("GP Texture Changed!")
	pass # Replace with function body.
