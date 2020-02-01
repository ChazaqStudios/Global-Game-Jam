extends Area2D
const SPEED = 1500
var d=1.32
var dano=30
export (int)var _scale=1
var speed_x
var speed_y
var angulo
var vec=Vector2(0,-1)
var damage_type
var addtion
func _ready():
	angulo=get_rotation_degrees()
	vec=vec.rotated(deg2rad(angulo))
	set_process(true)
	
func _physics_process(delta):

	get_node("Sprite").set_scale( Vector2(_scale,_scale))
	get_node("CollisionShape2D").set_scale( Vector2(_scale,_scale))
	var motion= vec * SPEED
	set_position(get_position()+ motion *delta)

	#dano-=20/60
	#_scale-=20/60
	if dano<=0:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_TiroD_body_entered(body):
	if body.has_method("Dano"):
		body.Dano(dano,damage_type,addtion)
	queue_free()