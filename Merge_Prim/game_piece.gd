extends Area2D

@export var texture_index = 0
var pokemart_textures = ["res://pokemerge/pokemart01.png", 
"res://pokemerge/pokemart02.png", "res://pokemerge/pokemart03.png",
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
	$pokemart.texture=load(pokemart_textures[0])
	m_grid_size = $pokemart.get_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# divide mouse position by grid size, use floorf to disard decimal
	# then multiply by grid size
	m_grid_size.x /= 4
	m_grid_size.y /= 4
	var v_x : float = floorf(get_global_mouse_position().x / m_grid_size.x) * m_grid_size.x
	var v_y : float = floorf(get_global_mouse_position().y / m_grid_size.y) * m_grid_size.y
	
	#set global position
	#global_position = Vector2(v_x, v_y);
	
	# offset by HALF grid size
	#global_position = global_position + (m_grid_size / 8)

func _input(event):
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
		$pokemart.position = to_global(event.position)

	if event.is_action_pressed("left_mouse_click"):
		if $pokemart.get_rect().has_point(to_local(event.position)):
			print("How big a click?", $pokemart.get_rect().size)
			#print("texture_array.size = ", texture_array.size())
			#print("texture_index = ", texture_index)
			texture_index += 1
			if texture_index > pokemart_textures.size() - 1:
				texture_index = 0
			$pokemart.texture=load(pokemart_textures[texture_index])
