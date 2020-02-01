extends KinematicBody2D

export(PackedScene) var Tiro
export(PackedScene) var drop

onready var sprite= get_node("sprite")

const SPEED= 100
const WALK_FORCE = 300
const GRAVITY = 1800 # pixels/second/second

var vivo= true
var fim=false
var direcao=Vector2(1,0)
var HPI=50
var atira=false
var ultimodisparo=3
var recuo=2
var natela=false
var podeatirar=false
var mira
var alvo
var velocity = Vector2()
var jumping = false
var prev_jump_pressed = false
var force= Vector2()
func _physics_process(delta):


	if alvo!=null:
		if alvo.get_global_position().x>get_global_position().x:
			direcao.x=1
			mira=1
		if alvo.get_global_position().x<get_global_position().x:
			direcao.x=-1
			mira=-1
		if  Vector2(alvo.get_global_position().x-get_global_position().x,0).length()<400:
			direcao.x=0
			atira=true
		force.x=WALK_FORCE*direcao.x
		if mira==1:
			sprite.set_flip_h(false)
		elif mira==-1:
			sprite.set_flip_h(true)
	
	if get_position().y>=900:
		queue_free()

	if HPI<=0:
		morrer()
	
	if ultimodisparo>0:
		ultimodisparo-=delta

	if atira==true and vivo and natela and podeatirar:
		if ultimodisparo <=0:
			atira(direcao.x)
			ultimodisparo=recuo
	if force.x==0:
		get_node("sprite").play("stop")
	elif force.x!=0:
		get_node("sprite").play("New Anim")
	force.y+=GRAVITY*delta
	force = move_and_slide(force, Vector2(0, -1),true)

	if get_position().y >1900:morrer()

func morrer():
	randomize()
	if not vivo: return 
	vivo = false
	velocity.y=-500
	HPI=0
	if randi()%4+1==1:
		var dop
		dop=drop.instance()
		dop.set_global_position(get_global_position())
		var tipodedrop
		tipodedrop=randi()%3+1
		if tipodedrop==2:
			dop.balas=randi()%3+1
		else:
			dop.poweruptipe=1
			dop.balas=0
		get_parent().add_child(dop)
	queue_free()

func _on_Fim_body_entered(body):
	fim=true #place with function body
	emit_signal("fim")
func atira(direcao):
	var bala = Tiro.instance()
	get_parent().add_child(bala)
	bala.set_position(get_node("Canoi").get_global_position())
	match mira:
		-1:
			bala.set_rotation_degrees(-90)
			var canox=get_node("Canoi").get_global_position().x
			var canoy=get_node("Canoi").get_global_position().y
			bala.set_position(Vector2(canox-72,canoy))
		1:
			bala.set_rotation_degrees(90)
			
	bala._ready()



func _on_VisibilityNotifier2D_screen_entered():
	natela=true
	HPI=75
	get_node("VisibilityNotifier2D/Timer").start()


func _on_Timer_timeout():
	podeatirar=true


func Dano(dano,type,add):
	if type=="critical":
		morrer()
	HPI-=dano

func criticaldmg():
	print("critical")
	Dano(HPI,"critical",null)

func _on_viso_body_entered(body):
	if alvo==null and alvo!=body:
		alvo=body
	if Vector2((alvo.get_global_position().x-get_global_position().x),0).length()>Vector2((body.get_global_position().x-get_global_position().x),0).length() and alvo!=body:
		alvo=body
	