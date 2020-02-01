extends Node

var stages=["FaseAlpha","Fase1"]
var current_stage=["FaseAlpha"]
var next_path
var jogadores=[1,0]
var selected_caracters=[0,0]
#--------------input----------------------------#
var j1left
var j1right
var j1up
var j1down
var j1square
var j1circle
var j1x
var j1triangulo
var j1start
var j1select
var j1l1
var j1l2
var j1r1
var j1r2

var j2left
var j2right
var j2up
var j2down
var j2square
var j2circle
var j2x
var j2triangulo
var j2start
var j2select
var j2l1
var j2l2
var j2r1
var j2r2

var kleft
var kright
var kup
var kdown
var ksquare
var kcircle
var kx
var ktriangulo
var kstart
var kselect
var kl1
var kl2
var kr1
var kr2
#----------------------------
var loader
var wait_frames
var time_max = 100 # msec
var current_scene


	
func trocar_cena(path,scene_to_remove): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	set_process(true)

	scene_to_remove.queue_free()
	wait_frames = 1
func _process(time):
	if loader == null:
		set_process(false)
		return
	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			#show_error()
			loader = null
			break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	get_node("ProgressBar").set_value(progress*100)

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	get_node("ProgressBar").visible=false
	


func set_stage(stage):
	current_stage=stages[stage]
func get_stage():
	return current_stage[0]
func input():
	j1left=Input.is_action_pressed("control1left")
	j1right=Input.is_action_pressed("control1right")
	j1up=Input.is_action_pressed("control1up")
	j1down=Input.is_action_pressed("control1down")
	j1square=Input.is_action_pressed("control1square")
	j1circle=Input.is_action_pressed("control1circle")
	j1x=Input.is_action_pressed("control1X")
	j1triangulo=Input.is_action_just_pressed("control1triangulo")
	j1start=Input.is_action_pressed("Start")
	j1select=Input.is_action_pressed("Select")
	j1l1=Input.is_action_pressed("control1l1")
	j1l2=Input.is_action_pressed("control1l2")
	j1r1=Input.is_action_pressed("control1r1")
	j1r2=Input.is_action_pressed("control1r2")
	
	j2left=Input.is_action_pressed("control2left")
	j2right=Input.is_action_pressed("control2right")
	j2up=Input.is_action_pressed("control2up")
	j2down=Input.is_action_pressed("control2down")
	j2square=Input.is_action_pressed("control2square")
	j2circle=Input.is_action_pressed("control2circle")
	j2x=Input.is_action_pressed("control2X")
	j2triangulo=Input.is_action_pressed("control2triangulo")
	j2start=Input.is_action_pressed("control2 start")
	j2select=Input.is_action_pressed("control2 select")
	j2l1=Input.is_action_pressed("control2l1")
	j2l2=Input.is_action_pressed("control2l2")
	j2r1=Input.is_action_pressed("control2r1")
	j2r2=Input.is_action_pressed("control2r2")
	
	kleft=Input.is_action_pressed("keyboardleft")
	kright=Input.is_action_pressed("keyboardright")
	kup=Input.is_action_pressed("keyboardup")
	kdown=Input.is_action_pressed("keyboarddown")
	ksquare=Input.is_action_pressed("keyboardsquare")
	kcircle=Input.is_action_pressed("keyboardcircle")
	kx=Input.is_action_pressed("keyboardcross")
	ktriangulo=Input.is_action_just_pressed("keyboardtriangulo")
	
func set_players(players,caracters):
	jogadores=players
	caracters=selected_caracters
	