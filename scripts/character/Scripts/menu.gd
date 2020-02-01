extends Node2D
var opcao=0
var player
var save_file=File.new()
var local_save="user://savegame.save"
var save_data={"jogadores":0}

func _ready():
	
	#if not save_file.file_exist(local_save):
	#create_save()
	get_node("Panel").hide()
	if Musicplayer.is_playing()==false:
		Musicplayer.play()

	if OS.get_name() !="HTML5":
		get_node("web").hide()
#func create_save():
#	save_file.open(local_save, File.WRITE)
#	save_file.store_var(save_data)
#	save_file.close()
#func save():
#	save_data["jogadores"] = jogadores
#	save_file.open(local_save,File.WRITE)
#	save_file.store_var(save_data)
#	save_file.close()
func _process(delta):
	if OS.get_name() !="HTML5":
		get_node("web").hide()
	elif OS.window_fullscreen():
		$web.hide()
	var select=Input.is_action_pressed("ui_accept")
	var cima=Input.is_action_just_pressed("ui_up")
	var cimaa=Input.is_action_just_pressed("cima")
	var baixo=Input.is_action_just_pressed("ui_down")
	var baixoa=Input.is_action_just_pressed("baixo")
	if select:
		get_node("Panel").hide()
		if opcao==0:
			_on_TextureButton_pressed()
		elif opcao==1:
			_on_TextureButton2_pressed()
		elif opcao==20:
			_on_TextureButton3_pressed()
		elif opcao==2:
			_on_TextureButton4_pressed()
		elif opcao==3:
			_on_TextureButton5_pressed()
		elif opcao==4:
			_on_TextureButton6_pressed()
	elif baixo or baixoa:
		get_node("Troca").play()
		get_node("Panel").hide()
		if opcao<4:
			opcao+=1
		else:
			opcao=0
		
	elif cima or cimaa:
		get_node("Troca").play()
		get_node("Panel").hide()
		if opcao>0:
			opcao-=1
		else:
			opcao=4

	
	if opcao==0:
		deselecionar()
		_on_TextureButton_mouse_entered()
	elif opcao==1:
		deselecionar()
		_on_TextureButton2_mouse_entered()
	elif opcao==30:
		deselecionar()
		_on_TextureButton3_mouse_entered()
	elif opcao==2:
		deselecionar()
		_on_TextureButton4_mouse_entered()
	elif opcao==3:
		deselecionar()
		_on_TextureButton5_mouse_entered()
	elif opcao==4:
		deselecionar()
		_on_TextureButton6_mouse_entered()
		
	var sis=OS.get_name()
	if sis=="HTML5":
		if OS.window_fullscreen==false:
			OS.set_window_fullscreen(true)
func _on_TextureButton_pressed():
	JogadorNODE.jogadores=1
	#save()
	get_tree().change_scene("res://Cenas/Fase1.tscn")
	#transition.fade_to("res://Fase1.tscn")
func _on_TextureButton2_pressed():
	JogadorNODE.jogadores=2
	#save()
	#var j=load("res://Fase1.tscn").instance().get_node("personagens").jogadores
	transition.fade_to("res://Cenas/Fase1.tscn")

func _on_TextureButton_mouse_entered():
	var scale=get_node("Control/Jogador 1").set_scale( Vector2(1.1,1.1))

	if not opcao==0:
		opcao=0
		get_node("Troca").play()


func _on_TextureButton_mouse_exited():
	var scale=get_node("Control/Jogador 1").set_scale( Vector2(1,1))


func _on_TextureButton2_mouse_entered():
	var scale=get_node("Control/Jogador 2").set_scale( Vector2(1.1,1.1))

	#get_node("Control/TextureButton/Text2").set_color("font_color",tex Color(255,0,0))
	if not opcao==1:
		opcao=1
		get_node("Troca").play()

func _on_TextureButton2_mouse_exited():
	var scale=get_node("Control/Jogador 2").set_scale( Vector2(1,1))


func _on_TextureButton3_mouse_entered():
	var scale=get_node("Control/I").set_scale( Vector2(1.1,1.1))

	if not opcao==20:
		opcao=20
		get_node("Troca").play()

func _on_TextureButton3_mouse_exited():
	#var scale=get_node("Control/I").set_scale( Vector2(1,1))
	pass
func _on_TextureButton4_mouse_entered():
	var scale=get_node("Control/Configurações").set_scale( Vector2(1.1,1.1))
	if not opcao==2:
		opcao=2
		get_node("Troca").play()


func _on_TextureButton4_mouse_exited():
	var scale=get_node("Control/Configurações").set_scale( Vector2(1,1))


func _on_TextureButton5_mouse_entered():
	var scale=get_node("Control/TextureButton5").set_scale( Vector2(1.1,1.1))
	if not opcao==3:
		opcao=3
		get_node("Troca").play()

func _on_TextureButton5_mouse_exited():
	var scale=get_node("Control/TextureButton5").set_scale( Vector2(1,1))

func _on_TextureButton6_mouse_entered():
	var scale=get_node("Control/Sair").set_scale(Vector2(1.1,1.1))

	if not opcao==4:
		opcao=4
		get_node("Troca").play()
func _on_TextureButton6_mouse_exited():
	var scale=get_node("Control/Sair").set_scale( Vector2(1,1))


func deselecionar():
	if opcao==0:
		_on_TextureButton2_mouse_exited()
		_on_TextureButton3_mouse_exited()
		_on_TextureButton4_mouse_exited()
		_on_TextureButton5_mouse_exited()
		_on_TextureButton6_mouse_exited()
	elif opcao==1:
		_on_TextureButton_mouse_exited()
		_on_TextureButton3_mouse_exited()
		_on_TextureButton4_mouse_exited()
		_on_TextureButton5_mouse_exited()
		_on_TextureButton6_mouse_exited()
	elif opcao==20:
		_on_TextureButton_mouse_exited()
		_on_TextureButton2_mouse_exited()
		_on_TextureButton4_mouse_exited()
		_on_TextureButton5_mouse_exited()
		_on_TextureButton6_mouse_exited()
	elif opcao==2:
		_on_TextureButton_mouse_exited()
		_on_TextureButton2_mouse_exited()
		_on_TextureButton3_mouse_exited()
		_on_TextureButton5_mouse_exited()
		_on_TextureButton6_mouse_exited()
	elif opcao==3:
		_on_TextureButton_mouse_exited()
		_on_TextureButton2_mouse_exited()
		_on_TextureButton3_mouse_exited()
		_on_TextureButton4_mouse_exited()
		_on_TextureButton6_mouse_exited()
	elif opcao==4:
		_on_TextureButton_mouse_exited()
		_on_TextureButton2_mouse_exited()
		_on_TextureButton3_mouse_exited()
		_on_TextureButton4_mouse_exited()
		_on_TextureButton5_mouse_exited()

func _on_TextureButton3_pressed():
	pass # replace with function body

func _on_TextureButton4_pressed():
	get_node("Panel2").show()

func _on_TextureButton5_pressed():
	
	get_node("Panel").show()

func _on_TextureButton6_pressed():
	get_node("Control/Sair/Sprite2/Sair").show()

func _on_credito_pressed():
	get_node("Panel").hide()

func _on_credito2_pressed():
	get_node("Panel2").hide()

func _on_Full_pressed():
	if OS.window_fullscreen==false:
		OS.set_window_fullscreen(true)
	else:
		OS.set_window_fullscreen(false)

func _on_Full2_pressed():
	#mudar idioma
	pass
func _on_Button2_pressed():
	get_node("Control/Sair/Sprite2/Sair").hide()


func _on_Button_pressed():
	get_tree().quit()

func _on_Teste_pressed():
	JogadorNODE.jogadores=1
	#save()
	get_tree().change_scene("res://Cenas/Fase de teste.tscn")

func _on_web_pressed():
	OS.set_window_fullscreen(true)
	
