extends Node


func _on_full_pressed():
	if OS.window_fullscreen==false:
		OS.set_window_fullscreen(true)
	else:
		OS.set_window_fullscreen(false)



func _on_Area2D_body_entered(body):
	print("aqui")
	print(body)
	if has_method("fim"):
		body.fim()
