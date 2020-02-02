extends Node2D

export (int,"Coelho","Cobra","Sapo","totem3","totem4","totem5") var actual_totem=0

var totens=[preload("res://assets/totens/toten0.png"),preload("res://assets/totens/toten1.png"),preload("res://assets/totens/toten2.png"),preload("res://assets/totens/toten3.png"),preload("res://assets/totens/toten4.png"),preload("res://assets/totens/toten5.png")]
onready var image=get_node("Sprite") 

func _ready():
	image.set_texture(totens[actual_totem])
	get_node("Particles2D").set_texture(totens[actual_totem])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.has_method("new_totem"):
		get_node("Area2D").set_monitoring(false) 
		body.new_totem(actual_totem)
		get_node("AnimationPlayer").play("Caught")
