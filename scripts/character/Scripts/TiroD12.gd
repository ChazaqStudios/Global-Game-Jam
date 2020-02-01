extends Node2D

func _ready():
	for children in get_children():
		children._ready()
