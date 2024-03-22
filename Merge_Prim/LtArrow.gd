extends Sprite2D


func _input(event):
	if event.is_action_pressed("left_mouse_click"):
		if get_rect().has_point(to_local(event.position)):
			#print("Left Arrow Left Mouse Clicked")
			get_parent().get_node("Notebook").previous_page()
