extends Area2D
const SPEED = 2200
var dano=150
var vec=Vector2(0,-1)
var angulo
var alvo
var damage_type
var addtion
func _ready():

	angulo=get_rotation_degrees()
	vec=vec.rotated(deg2rad(angulo))
	"""
	var angulo=get_rotation_degrees()
	if angulo>180:
		angulo-=360
	elif angulo<-180:
		angulo+=360
	if angulo<=90 and angulo>=-90:
		speed_x=angulo*vl
	
	elif angulo>90:
		speed_x=(6.5*2)-angulo*vl
	
	elif angulo<-90:
		speed_x=(-6.5*2)-angulo*vl
	elif angulo==0:
		speed_x=0

	if angulo>0:
		speed_y=-6.5+(angulo*vl)
	elif angulo<=0:
		speed_y=-6.5+(angulo*vl)*-1
		"""
	set_process(true)
	
func _physics_process(delta):

	var motion= vec * SPEED
	set_position(get_position()+ motion *delta)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_TiroD_body_entered(body):
	if body.has_method("Dano"):
		if body.has_method("criticaldmg") and body==alvo:
			body.criticaldmg()
		else:
			body.Dano(dano,damage_type,addtion)
		dano-=10

	queue_free()
	

func set_target(target):
	alvo=target
