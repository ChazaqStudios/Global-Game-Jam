extends KinematicBody2D
export(int) var player
export (Array,PackedScene) var preloadwepons
var personagem="default"
signal morreu# emit um sinal que é repassado para um node superior para executar uma função, nesse caso faz o personagem morrer

onready var rayE = get_node("RayE")#variaveis para declarar 2 raycasts que serão usados para detectar colisões RayE e RayD detecta se o lado esquerdo do personagem esta colidindo com o solo
onready var rayD = get_node("RayD")
onready var sprite= get_node("sprite")
onready var personagem_info = {
	"armas":{
	"weapon_slot":weapon_slot,
	0:preloadwepons[0],
	1:preloadwepons[1],
	2: preloadwepons[2],
	3: preloadwepons[3]},
	"recuo":{
				0: .3,
				1:.15,
				2: .5,
				3: .5 #recuo é o tempo que uma arma vai levar para disparar, o primeiro valor é da metralhadora, o segundo da shotgun e o terceiro da sniper
			},
	"municao":{
		1:0,
		2:0,
		3:0
			},
	"HP":1,
	"Weapon_anim":null,
	"Max_HP":100,
	"Personagem_name":"default"
}
const GRAVITY = 1800 # pixels/second/second
const FLOOR_ANGLE_TOLERANCE = 40
const JUMP_MAX_AIRBORNE_TIME = 0.3

var WALK_FORCE = 350
var JUMP_SPEED = 800
var living = true#variavel que indica se o inimigigo esta vivo ou morto
var direcao = 6#variavel usada para definir a direção para onde o personagem esta olhando, 1 é igual a left e 3 é igual a direita
var weapon_cooldown = 0# variavel usada para calcular o tempo que vai demorar para a arma disparar novamente
var adictional
var dash_cooldown=0
var dash_force=1300
var in_dash=false
var dash_time=0
export (float) var dash_total_time=0.2
var dash_dir
var vidas = 5#numero de vidas do jogador
var tipodeselected_weapon=0#variavel para definir o tipo de arma que o personagem usa
var weapon_slot = [0,0]
var selecionada = 0
var target
var locking=0.5 #é um valor usado para a 
var tangivel#define se o personagem pode ser atingido
var stop
var munition=[0,50,15,20]
var last_pos
#----------input--------------
var left
var right
var up
var down
var quadrado
var circulo
var triangulo
var cross 
var l1
var l2
var l3
var r1
var r2
var r3
#-------------------------
var snap=Vector2(0,64)
var movement = Vector2()
var on_air_time = 100
var jumping = false
var on_floor=true
var prev_jump_pressed = false
var lastdir
var anim
var atack_type="shoot"
var last_btn

func _ready():

	connect("morreu", get_parent(),"morreu")
	player=get_parent().get_player()

	personagem_info.HP=100
	tangivel=true


func _physics_process(delta):
	
	snap=Vector2(0,64)
	if living:
		last_pos=Vector2(get_global_position().x, 500)
	input()
	if personagem_info.HP<=0:
		morrer()
	mira()
	
	if weapon_cooldown>0:
		weapon_cooldown-=delta
	if dash_cooldown>0:
		dash_cooldown-=delta

	use_input(delta)

	movement.y +=GRAVITY*delta
	if in_dash:
		dash(delta,lastdir)
	if rayE.is_colliding() or rayD.is_colliding() or is_on_floor():
		on_floor=true
	else:
		on_floor=false
	movement = move_and_slide_with_snap(movement,snap, Vector2(0, -1), true, 4, deg2rad(45) )
func input():
	Globalscript.input()
	if player==1 and Globalscript.jogadores[1]==0:
		left=Globalscript.kleft or Globalscript.j1left
		right=Globalscript.kright or Globalscript.j1right
		up=Globalscript.kup or Globalscript.j1up
		down=Globalscript.kdown or Globalscript.j1down
		quadrado=Globalscript.ksquare or Globalscript.j1square
		circulo=Globalscript.kcircle or Globalscript.j1circle
		triangulo=Globalscript.ktriangulo or Globalscript.j1triangulo
		cross=Globalscript.kx or Globalscript.j1x
		l1=Globalscript.kl1 or Globalscript.j1l1
		l2=Globalscript.kl2 or Globalscript.j1l2
		r1=Globalscript.kr1 or Globalscript.j1r1
		r2=Globalscript.kr2 or Globalscript.j1r2
	
	elif player==1:
		left=Globalscript.kleft
		right=Globalscript.kright
		up=Globalscript.kup
		down=Globalscript.kdown
		quadrado=Globalscript.ksquare
		circulo=Globalscript.kcircle
		triangulo=Globalscript.ktriangulo
		cross=Globalscript.kx
		l1=Globalscript.kl1
		l2=Globalscript.kl2
		r1=Globalscript.kr1
		r2=Globalscript.kr2
	elif player==2:
		left=Globalscript.j1left
		right=Globalscript.j1right
		up=Globalscript.j1up
		down=Globalscript.j1down

		quadrado=Globalscript.j1square
		circulo=Globalscript.j1circle
		triangulo=Globalscript.j1triangulo
		cross=Globalscript.j1x
		l1=Globalscript.j1l1
		l2=Globalscript.j1l2
		r1=Globalscript.j1r1
		r2=Globalscript.j1r2

	elif player==3:
		left=Globalscript.j2left
		right=Globalscript.j2right
		up=Globalscript.j2up
		down=Globalscript.j2down

		quadrado=Globalscript.j2square
		circulo=Globalscript.j2circle
		triangulo=Globalscript.j2triangulo
		cross=Globalscript.j2x
		l1=Globalscript.j2l1
		l2=Globalscript.j2l2
		r1=Globalscript.j2r1
		r2=Globalscript.j2r2


func use_input(delta):
	movement.x = 0
	if triangulo and living:
		trocararma()
		print("troca")

	if quadrado and living:
		atack()
		
	direcao=lastdir
	if not(left and right) and (left or right):
		if left and living and not in_dash: 
				sprite.set_flip_h(true)
				movement.x -=1*WALK_FORCE
				stop = false
				direcao=4
				lastdir=direcao
				last_btn=-1
		if right and living and not in_dash:
				sprite.set_flip_h(false)
				movement.x +=1*WALK_FORCE
				stop = false
				direcao=6
				lastdir=direcao
				last_btn=1
	elif (left and right):
		if last_btn==1 and living and not in_dash: 
					sprite.set_flip_h(true)
					movement.x -=1*WALK_FORCE
					stop = false
					direcao=4
					lastdir=direcao
		elif last_btn==-1 and living and not in_dash:
					sprite.set_flip_h(false)
					movement.x +=1*WALK_FORCE
					stop = false
					direcao=6
					lastdir=direcao

	if down and living and not in_dash:
		get_node("shape").disabled=true
		get_node("sprite").play("Abaixado")
		if on_floor==false:
			direcao=2
	if circulo and(left or right) and not in_dash:
		in_dash=true
	if up and right:
		direcao=9
	elif up and left:
		direcao=7
	elif up:
		direcao=8

	if not down and living:
		get_node("shape").disabled=false
		if get_node("sprite").get_animation()=="Abaixado":
			get_node("sprite").play("Parado")

	if is_on_floor():
		on_air_time = 0
		
	if jumping and movement.y > 0:
		# If falling, no longer jumping
		jumping = false

	if on_air_time < JUMP_MAX_AIRBORNE_TIME and cross and not prev_jump_pressed and not jumping and living:
		pular()

	if (left or right) and on_floor and living and not down:
		sprite.play("Dimitri")
	elif (cross):
		sprite.play("New Anim")
		if rayE.is_colliding() or rayD.is_colliding():
			sprite.stop()
			sprite.set_frame(0)
	else:
		sprite.stop()
		sprite.set_frame(0)
		pass
	on_air_time += delta
	prev_jump_pressed = cross
	if get_position().y >900:morrer()

func pular():
	snap=Vector2()
	movement.y = -JUMP_SPEED
	jumping = true
	 
func morrer():
	if living:
		emit_signal("morreu",self,vidas)
	movement.y=GRAVITY
	personagem_info.HP=0
#
	
	living = false

func respawn():

	get_node("spawn").start()

func mira():
	match direcao:
		1:
			get_node("Cano").set_rotation_degrees(-135)
		2:#down
			get_node("Cano").set_rotation_degrees(180)
		3:
			get_node("Cano").set_rotation_degrees(135)
		4:#esqueda
			get_node("Cano").set_rotation_degrees(-90)

		6:#direita
			get_node("Cano").set_rotation_degrees(90)
		7:
			get_node("Cano").set_rotation_degrees(-45)
		8:#alto
			get_node("Cano").set_rotation_degrees(0)
		9:
			get_node("Cano").set_rotation_degrees(45)

func atack():
	get_node("Melee range").set_monitorable(true)
	var selected_weapon
	if weapon_cooldown <=0: #determina a cadencia de disparo, quando for menot que 0 significa que já é possivel atirar novamente
		if atack_type=="shoot":
			if tipodeselected_weapon!=0:
				if personagem_info.municao[tipodeselected_weapon]>=1:
						personagem_info.municao[tipodeselected_weapon]-=1
				else:
					descarrega()

			var rot=get_node("Cano").get_rotation_degrees()
			
			weapon_cooldown=personagem_info.recuo[tipodeselected_weapon]
			selected_weapon= personagem_info.armas[tipodeselected_weapon].instance()
			get_parent().add_child(selected_weapon)
			selected_weapon.set_rotation_degrees(rot)
			selected_weapon.set_position(get_node("Cano/Cano").get_global_position())
			selected_weapon._ready()
			if target!=null and selected_weapon.has_method("set_target"):
				selected_weapon.set_target(target)
				target=null
			get_node("Sons de arma/"+str(tipodeselected_weapon)).play()
			
		if atack_type=="melee":
			atack_type="shoot"
	locking=weapon_cooldown
	
func descarrega():
	#o futuro chegou e esqueci de tirar o outro comentario
	if tipodeselected_weapon==weapon_slot[0]:
		tipodeselected_weapon=0
		weapon_slot[0]=0
	elif tipodeselected_weapon==weapon_slot[1]:
		tipodeselected_weapon=0
		weapon_slot[1]=0
	personagem_info.tipodeselected_weapon=tipodeselected_weapon

func dano(dano,tipo_de_dano,adicao_de_dano):
	if tangivel:
		personagem_info.HP-=dano
		get_node("Cooldown").start()
		get_node("AnimationPlayer").play("Cooldown")
		tangivel=false
		
func trocararma():
	if tipodeselected_weapon==weapon_slot[0]:
			tipodeselected_weapon=weapon_slot[1]
			if selecionada==1:
				selecionada=2
				personagem_info.Weapon_anim=2
				#chamar animação 2
	elif tipodeselected_weapon==weapon_slot[1]:
			tipodeselected_weapon=weapon_slot[0]
			if selecionada==2:
				selecionada=1
				personagem_info.Weapon_anim=1
				#chamar a animação 1
	personagem_info.weapon_slot=weapon_slot
	
func pegarma(droped_weapon):
	#a função vai receber a variavel droped_weapon, que vai vir do power up coletado, em weapon_slot é um array usado para armazenar as armas
	if weapon_slot[0]==0:#se não tiver uma arma no slot 1, a arma vai ser igual a pega
		weapon_slot[0]=droped_weapon
		tipodeselected_weapon=weapon_slot[0]
		selecionada=1 #difne qual arma o jogador está usando
		personagem_info.Weapon_anim=0
		 #chamar a animação para pegar arma
		personagem_info.municao[droped_weapon]+=munition[droped_weapon]

	elif weapon_slot[1]==0:#se não tiver uma arma no slot 1, a arma vai ser igual a pega
		#chamar a animação do hud para arma2
		personagem_info.Weapon_anim=2
		weapon_slot[1]=droped_weapon
		tipodeselected_weapon=weapon_slot[1]
		selecionada=2
	
		personagem_info.municao[droped_weapon]+=munition[droped_weapon]
	elif droped_weapon!=weapon_slot[0] and droped_weapon!=weapon_slot[1]:

		if selecionada==1:
			weapon_slot[0]=droped_weapon
			tipodeselected_weapon=weapon_slot[0]

		elif selecionada==2:
			weapon_slot[1]=droped_weapon
			tipodeselected_weapon=weapon_slot[1]

		personagem_info.municao[droped_weapon]+=munition[droped_weapon]
		
	weapon_cooldown=0.5
func set_target(target):#passa a selected_weapon um alvo
	self.target=target

func desativado():
	queue_free()

func _on_Cooldown_timeout():
	tangivel=true


		
func get_status():
	var ammo=[0,0]
	if weapon_slot[0]==0:
		ammo[0]=" "
	else:
		ammo[0]=personagem_info.municao[weapon_slot[0]]

	if weapon_slot[1]==0:
		ammo[1]=" "
	else:
		ammo[1]=personagem_info.municao[weapon_slot[1]]
	return [personagem_info.HP,weapon_slot, ammo, personagem_info.Weapon_anim ]

func UP_HP(hp):
	if (personagem_info.HP+hp)>personagem_info.Max_HP:
		personagem_info.HP=personagem_info.Max_HP
	else:
		personagem_info.HP+=hp
	
func _on_spawn_timeout():
	living=true
	personagem_info.HP=100
	tangivel=false
	$Cooldown.start()
	get_node("AnimationPlayer").play("Cooldown")
	set_global_position(last_pos)
func dash(delta,dir):
	if dir==6:
		dash_dir=1
	elif dir==4:
		dash_dir=-1
	if dash_cooldown<=0:
		dash_cooldown=.5

		dash_time=dash_total_time
	if dash_time>0:
		movement.x+=(WALK_FORCE+dash_force)*dash_dir
		dash_time-=delta
	else:
		in_dash=false


func set_personagem_singularity(move_speed, jumping,personagem,weapons, personagem_info):
	self.WALK_FORCE=move_speed
	self.JUMP_SPEED=jumping
	self.personagem=personagem
	self.preloadwepons=weapons
	self.personagem_info=personagem_info

func _on_Melee_range_body_entered(body):
	if body.has_method("dano"):
		body.dano(25, "melee",adictional)
	atack_type="melee"

#	get_node("Melee range").set_monitoring(false)


func get_lifes():
	return vidas
