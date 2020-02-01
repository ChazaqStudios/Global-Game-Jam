extends Area2D
const SPEED = 1300;
var d=1.32
var dano=25
var s=1
var vec=Vector2(0,-1)
var angulo
var damage_type
var addtion
func _ready():
	angulo=get_rotation_degrees()
	vec=vec.rotated(deg2rad(angulo))
	
	"""
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
		set_process(true)
		"""
	
func _physics_process(delta):

	var motion= vec * SPEED
	set_position(get_position()+ motion *delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_TiroD_body_entered(body):
	if body.has_method("Dano"):
		body.Dano(dano,damage_type,addtion)
	queue_free()

func set_weapon(speed):
	pass