extends Node2D
func _ready():
	_process(true)
func _process(delta):
	var pause1=Input.is_action_pressed("pause")
	var p=Input.is_action_just_pressed("baixo")
	var t=Input.is_action_just_pressed("ui_up")
	var a=Input.is_action_just_pressed("ui_down")
	
	if pause1:
		emit_signal("despausar")
		get_tree().paused=true
	elif p:
		print("p")
	elif t:
		print("t")
	elif a:
		print("a")