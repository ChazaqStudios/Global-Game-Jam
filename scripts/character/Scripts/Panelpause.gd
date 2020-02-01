extends Panel
signal despausar
signal pausar
var pausado
func _ready():
	if OS.get_name()=="Android":
		get_node("full").visible=false
	pausado=false
	_process(true)
func _process(delta):
	var pause1=Input.is_action_just_pressed("pause")
	if pause1 and not pausado:
		#get_tree().paused=false
		#if get_parent().hide()==false:
		get_parent().get_parent().get_parent().get_tree().paused=(true)
		pausado=true
		set_visible(true)
		print("despausar")
	elif pause1 and pausado:
		pausado=false
		get_parent().get_parent().get_parent().get_tree().paused=(false)
		print("pausar")
		set_visible(false)
		#get_tree().change_scene("res://Menu.tscn")


func _on_full_pressed():
	if OS.window_fullscreen==false:
		OS.window_fullscreen=true
	else:
		OS.window_fullscreen=false


func _on_Button_pressed():
	get_tree().change_scene("res://Cenas/Menu.tscn")

