extends Node2D
var opcao=0

export(String, FILE, "*tscn") var cenas
var time=0
var jogadores=[0,0]
var selected=[0,0]
onready var anim=get_node("Control/Monitor/animation control").get("parameters/playback")
func _ready():
	
	if Musicplayer.is_playing()==false:
		Musicplayer.play()

func _on_Jogar_pressed():

	anim.travel("Change to modes")


func _on_sair_pressed():

	$botoes/Sair.show()



func _on_Arcade_pressed():
	anim.travel("Personagens config")


func _on_Personagem1_item_selected(ID):
	selected[0]=0
	jogadores[0]=1
	get_node("Control/MonitorPlayer1/crachar/Label").set_text("Dimitri")
	get_node("Control/MonitorPlayer1/crachar/Sprite").set_modulate("ffffff")
	get_node("Control/MonitorPlayer1/crachar/Description").set_text("Sniper profissional.\nAgente do Team zero")


func _on_Personagem2_item_selected(ID):
	selected[0]=0
	jogadores[1]=ID
	if ID==1:
		get_node("Control/MonitorPlayer2/crachar1/Name").set_text("Dimitri")
		get_node("Control/MonitorPlayer2/crachar1/Sprite").set_modulate("ffffff")
		get_node("Control/MonitorPlayer2/crachar1/Description").set_text("Sniper profissional.\nAgente do Team zero")
		selected[0]=0
		jogadores[1]=ID
	else:
		get_node("Control/MonitorPlayer2/crachar1/Name").set_text(" ")
		get_node("Control/MonitorPlayer2/crachar1/Sprite").set_modulate("000000")
		get_node("Control/MonitorPlayer2/crachar1/Description").set_text(" ")
		selected[0]=0
		jogadores[1]=0

func _on_iniciar_jogo_pressed():
	Globalscript.set_players(jogadores,selected)
	Globalscript.set_stage(0)
	Globalscript.trocar_cena(cenas,self)
	
