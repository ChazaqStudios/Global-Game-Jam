extends Area2D
const SPEED = 300;
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
	set_process(true)

func _process(delta):
	
	var motion=vec*SPEED

	set_position(get_position()+ motion *delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Tiro_inimigoD_body_entered(body):
	if body.has_method("dano"):
		body.dano(25,damage_type,addtion)
	queue_free()
	
