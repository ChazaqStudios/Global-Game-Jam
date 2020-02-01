extends AudioStreamPlayer



func _ready():
	play(0.0)



func _on_AudioStreamPlayer_finished():
	print("repitiu")
	play(0.0)
