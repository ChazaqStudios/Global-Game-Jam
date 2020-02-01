extends Node2D

export(Array,PackedScene)var caracter=[preload("res://Cenas/Personagens/Personagem base.tscn"),preload("res://Cenas/Personagens/Personagem base.tscn")]


onready var camera_node= get_node("camera")
onready var camera_position= get_node("camera").get_position()

var player1position=Vector2()#posição do jogador 1
var player2position=Vector2()#posição do jogador 2


var animacao1
var animacao2


var personagens=Globalscript.jogadores
var selected_caracters=Globalscript.selected_caracters
var time=[00,00,0]
var umjogador=true
var fim=false
var nasceu=true

var players_number=1
var players=[false,false]
var player1
var player2

func _ready():
	if OS.get_name()=="Android":
		$Android/Control.show()
	else:
		$Android/Control.hide()
	Engine.set_target_fps(60)

	if personagens[1] ==0 and personagens[0]!=0:
		#1jogador
		players_number=1

		player1=caracter[selected_caracters[0]].instance()
		add_child(player1)
		player1.set_global_position(get_node("Players/Player1").get_global_position() )
		get_node("HUD/Status/Player 2").hide()
	elif personagens[0] !=0 and personagens[1] !=0:
		#2jogadores 
		players_number=2
		player1=caracter[selected_caracters[0]].instance()
		player2=caracter[selected_caracters[1]].instance()
		add_child(player1)
		add_child(player2)
		player1.set_global_position(get_node("Players/Player1").get_global_position() )
		player2.set_global_position(get_node("Players/Player2").get_global_position() )




func _physics_process(delta):
	if time[time.size()-1]<60:
		time[time.size()-1]+=delta
	else:
		time[time.size()-1]=0
		if time[time.size()-2]<60:
			time[time.size()-2]+=1
		else:
			time[time.size()-3]+=1
			time[time.size()-2]=0
	get_node("HUD/Tempo").set_text("Tempo: "+str(int(time[0]) )+":"+ str(int(time[1])) +":"+ str(int(time[2])) )
	var pause1=Input.is_action_just_pressed("pause")
	var pause2=Input.is_action_just_pressed("pause2")

	var camera_position_y
	var camera_x_position = camera_position.x
	var screen_collider
	var camera_position= get_node("camera").get_position()
	var camera_position_x= camera_position.x

	var pausado=get_tree().paused

	player1position=player1.get_global_position()
	camera_position_y= camera_position.y
	screen_collider= get_node("camera/telad2")


	if players_number==1:
		if player1position.x>=camera_position_x:
			camera_node.set_position(Vector2(player1position.x, player1position.y))
		else:
			camera_node.set_position(Vector2(camera_position_x,player1position.y))

	if players_number == 2:
		
		player2position=player2.get_global_position()
		camera_node.set_global_position( Vector2 ( ((player1position.x+player2position.x) /2),camera_node.get_position().y) )
			#se o player 2 estiver na frete e o player 1 900 atras
#		if player2position.x>player1position.x and not player1position.x<=player2position.x-d and player2position.x>=camera_position_x:
#
#			camera_node.set_position(Vector2(player2position.x, player2position.y) )
#			screen_collider.set_position(Vector2(camera_x_position-950, camera_position_y) )
#
#		elif player1position.x>player2position.x and not player2position.x<=player1position.x-d and player1position.x>=camera_position_x:
#
#			camera_node.set_position(Vector2(player1position.x, player1position.y))
#			screen_collider.set_position(Vector2(camera_x_position-950, camera_position_y))
#			#se o player 1 estiver atras do 2 menos 400 e o player 1 estiver a frente do player 2 menos 1460
#		elif player1position.x<=player2position.x-d and  player1position.x>=player2position.x-1460 and player1position.x>=camera_position_x-d:
#
#			camera_node.set_position(Vector2(player1position.x+d, player1position.y))
#			screen_collider.set_position(Vector2(camera_x_position-950, camera_position_y) )
#
#		elif player2position.x<=player1position.x-d and player2position.x>=player1position.x-1460  and player2position.x>camera_position_x-d:
#
#			camera_node.set_position(Vector2(player2position.x+d, player2position.y))
#			screen_collider.set_position(Vector2(camera_x_position-950, camera_position_y) )

	refresh_hud()


func _on_Button_pressed():
	get_node("HUD/Pause/Panelpause").hide()
	get_tree().paused=false
	Globalscript.trocar_cena("res://Cenas/System/Menu.tscn",get_parent())


func morreu(player,lifes):
	if lifes>0:
		player.respawn()

func get_player():
	if players[0]==false:
		players[0]=true
		return 1
	elif players[1]==false and players[0]==true:
		return 2

func refresh_hud():
	#status é um array com os seguintes dados HP, Array com o numero das armas 1 e 2, munição das armas 1 e 2, animação do indicador de armas
	var status1=player1.get_status()
	var hp1=status1[0]
	get_node("HUD/Status/Player 1/HpBarPlayer1").set_value(hp1)
	get_node("HUD/Status/Player 1/Bullet number").set_text(str(status1[2][0]) )
	get_node("HUD/Status/Player 1/Bullet number2").set_text(str(status1[2][1]) )
	if animacao1!=status1[3]:
		match status1[3]:
			0:
				get_node("HUD/Status/Player 1/Tipo de arma").play("Arma1")
			1:
				get_node("HUD/Status/Player 1/Tipo de arma").play("Para arma 1")
			2:
				get_node("HUD/Status/Player 1/Tipo de arma").play("Para arma 2")
		animacao1=status1[3]

	match status1[1][0]:
		
		0:
			get_node("HUD/Status/Player 1/Arma1/Pistola").show()
			get_node("HUD/Status/Player 1/Arma1/shotgun").hide()
			get_node("HUD/Status/Player 1/Arma1/sniper").hide()
			get_node("HUD/Status/Player 1/Arma1/smg").hide()
		1:
			get_node("HUD/Status/Player 1/Arma1/Pistola").hide()
			get_node("HUD/Status/Player 1/Arma1/shotgun").hide()
			get_node("HUD/Status/Player 1/Arma1/sniper").hide()
			get_node("HUD/Status/Player 1/Arma1/smg").show()
		2:
			get_node("HUD/Status/Player 1/Arma1/Pistola").hide()
			get_node("HUD/Status/Player 1/Arma1/shotgun").hide()
			get_node("HUD/Status/Player 1/Arma1/sniper").show()
			get_node("HUD/Status/Player 1/Arma1/smg").hide() 
		3:
			get_node("HUD/Status/Player 1/Arma1/Pistola").hide()
			get_node("HUD/Status/Player 1/Arma1/shotgun").show()
			get_node("HUD/Status/Player 1/Arma1/sniper").hide()
			get_node("HUD/Status/Player 1/Arma1/smg").hide()
			

	match status1[1][1]:
		0:
			get_node("HUD/Status/Player 1/Arma2/Pistola").show()
			get_node("HUD/Status/Player 1/Arma2/shotgun").hide()
			get_node("HUD/Status/Player 1/Arma2/sniper").hide()
			get_node("HUD/Status/Player 1/Arma2/smg").hide()
		1:
			get_node("HUD/Status/Player 1/Arma2/Pistola").hide()
			get_node("HUD/Status/Player 1/Arma2/smg").show()
			get_node("HUD/Status/Player 1/Arma2/shotgun").hide()
			get_node("HUD/Status/Player 1/Arma2/sniper").hide()
		2:
			get_node("HUD/Status/Player 1/Arma2/Pistola").hide()
			get_node("HUD/Status/Player 1/Arma2/shotgun").hide()
			get_node("HUD/Status/Player 1/Arma2/sniper").show()
			get_node("HUD/Status/Player 1/Arma2/smg").hide()
		3:
			get_node("HUD/Status/Player 1/Arma2/Pistola").hide()
			get_node("HUD/Status/Player 1/Arma2/shotgun").show()
			get_node("HUD/Status/Player 1/Arma2/sniper").hide()
			get_node("HUD/Status/Player 1/Arma2/smg").hide()

	if players_number==2:
		var status2=player2.get_status()
		var hp2=status2[0]
		get_node("HUD/Status/Player 2/HpBarPlayer2").set_value(hp2)
		get_node("HUD/Status/Player 2/Bullet number").set_text(str(status2[2][0]) )
		get_node("HUD/Status/Player 2/Bullet number2").set_text(str(status2[2][1]) )
	if animacao1!=status1[3]:
		match status1[3]:
			0:
				get_node("HUD/Status/Player 2/Tipo de arma").play("Arma1")
			1:
				get_node("HUD/Status/Player 2/Tipo de arma").play("Para arma 1")
			2:
				get_node("HUD/Status/Player 2/Tipo de arma").play("Para arma 2")
		animacao1=status1[3]
		match status1[1][0]:
			0:
				get_node("HUD/Status/Player 2/Arma1/Pistola").show()
				get_node("HUD/Status/Player 2/Arma1/shotgun").hide()
				get_node("HUD/Status/Player 2/Arma1/sniper").hide()
			1:
				get_node("HUD/Status/Player 2/Arma1/Pistola").show()
				get_node("HUD/Status/Player 2/Arma1/shotgun").hide()
				get_node("HUD/Status/Player 2/Arma1/sniper").hide()
			2:
				get_node("HUD/Status/Player 2/Arma1/Pistola").hide()
				get_node("HUD/Status/Player 2/Arma1/shotgun").hide()
				get_node("HUD/Status/Player 2/Arma1/sniper").show()
			3:
				get_node("HUD/Status/Player 2/Arma1/Pistola").hide()
				get_node("HUD/Status/Player 2/Arma1/shotgun").show()
				get_node("HUD/Status/Player 2/Arma1/sniper").hide()
			
		match status1[1][1]:
			1:
				get_node("HUD/Status/Player 2/Arma2/shotgun").hide()
				get_node("HUD/Status/Player 2/Arma2/sniper").hide()
			2:
				get_node("HUD/Status/Player 2/Arma2/shotgun").hide()
				get_node("HUD/Status/Player 2/Arma2/sniper").show()
			3:
				get_node("HUD/Status/Player 2/Arma2/shotgun").show()
				get_node("HUD/Status/Player 2/Arma2/sniper").hide()

func get_distance(requester):
	if players_number==1:
		return player1position
	elif players_number==2:
		if player1position.x>requester.x and player2position.x>requester.x:
			if player1position.x>player2position.x:
				return player2position
			else:
				return player1position
		elif player1position.x<requester.x and player2position.x<requester.x:
			if player1position.x<player2position.x:
				return player2position
			else:
				return player1position

