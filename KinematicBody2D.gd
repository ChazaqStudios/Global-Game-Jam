extends KinematicBody2D


export (float,0,10,0.2)var gravity=9.8
export (int,0,700,10)var walk_speed=300
export (int,0,10000,10)var jump_speed_normal=600
export (int,0,10000,10)var jump_speed_totem=600
export (int,0,1000,10)var speed_max_normal=150
export (int,0,1000,10)var speed_max_totem=300
export (int,0,1000,10)var speed_min=30
export (int,0,1000,10)var hp_max
export (int,0,10000,10) var stop_force = 1300
export (float,0,3,0.1)var cool_down_padrao=0.1
export (Array) var totens = [false,false,false,false,false,false]

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

const FLOOR_ANGLE_TOLERANCE = 40
const JUMP_MAX_AIRBORNE_TIME = 0.3

onready var jag_sprite=get_node("Sprite")
onready var animation=get_node("AnimationPlayer")
onready var totens_node=get_node("CanvasLayer/totens")

var move_vec=Vector2()
var dir_vec=Vector2()
var live=true
var hp
var snap=Vector2(0,32)

var speed_max=300
var jump_speed=300
var jumping = false
var on_floor=true
var prev_jump_pressed = false

var velocity = Vector2()
var on_air_time = 100
var cool_down=0.2


func _ready():
	hp=hp_max

	actualise_totens()


func _physics_process(delta):
	# Create forces
	snap=Vector2(0,32)
	var force = Vector2(0, 100*gravity)

	var walk_left = Input.is_action_pressed("left")
	var walk_right = Input.is_action_pressed("right")
	var jump = Input.is_action_pressed("cross")
	var run= Input.is_action_pressed("square")
	var atack= Input.is_action_pressed("triangle")
#----------------movement-----------------------------------------------------
	if run and (totens[0]==true):
		speed_max=speed_max_totem
	else:
		speed_max=speed_max_normal

	if totens[0]==true:
		jump_speed=jump_speed_totem
	else:
		jump=jump_speed_normal

	var stop = true

	if walk_left:
		if velocity.x <= speed_min and velocity.x > -speed_max:
			force.x -= walk_speed
			stop = false
			jag_sprite.flip_h=true
	elif walk_right:
		if velocity.x >= -speed_min and velocity.x < speed_max:
			force.x += walk_speed
			stop = false
			jag_sprite.flip_h=false

	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)

		vlen -= stop_force * delta
		if vlen < 0:
			vlen = 0

		velocity.x = vlen * vsign
	
	if is_on_floor():
		on_air_time = 0

	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false

	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		snap=Vector2()
		velocity.y = -jump_speed
		jumping = true
		
	on_air_time += delta
	prev_jump_pressed = jump

	velocity += force * delta

	velocity = move_and_slide_with_snap(velocity, snap,Vector2(0, -1),true,40)
#-------------------animation----------------------------------------------------------
	if (velocity.x<0.2 and velocity.x>-0.2) and velocity.y==0 :
		animation.play("Idle")
	elif (velocity.x>0.2 or velocity.x<-0.2) and velocity.y==0:
		animation.play("Run")
	elif velocity.y!=0 and not (is_on_floor()):
		if animation.get_current_animation()!="Jump":
			animation.play("Jump")


#---------------------atack and interactions----------------------------------------------

	if cool_down>0:
		cool_down-=delta

	if atack:
		if cool_down<=0:
			cool_down=cool_down_padrao

func actualise_totens():
	var children=totens_node.get_children()
	for x in rand_range(0, children.size()-1):
		if totens[x]==true:
			children[x].visible=true
	

func new_totem(index):
	totens[index]=true
	print(index)
	actualise_totens()

