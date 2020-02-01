extends Position2D

export(int, "Drone","Shooter")var type=1

func _ready():
	get_node("Sprite").hide()

func _on_VisibilityNotifier2D_screen_entered():
	var enemy=get_parent().get_resorce(type)
	var pos=get_global_position()
	var instance=enemy.instance()
	get_parent().call_deferred("add_child",instance)
	instance.set_position(Vector2(pos.x+200,pos.y))
