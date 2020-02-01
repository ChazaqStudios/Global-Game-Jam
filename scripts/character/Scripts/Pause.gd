extends Panel
signal despausar
var pode
func _ready():
	_process(true)
	pode=false
func _process(delta):
	var pause1=Input.is_action_pressed("pause")
	var p=Input.is_action_just_pressed("baixo")
	var t=Input.is_action_just_pressed("ui_up")
	var a=Input.is_action_just_pressed("ui_down")
	
	if pause1 and pode:
		emit_signal("despausar")
		get_tree().paused=false
		get_parent().hide()
		print("despausar")
	elif p:
		print("p")
	elif t:
		print("t")
	elif a:
		print("a")

func _on_full_pressed():
	pass # replace with function body


func _on_Timer_timeout():
	pode=true # replace with function body