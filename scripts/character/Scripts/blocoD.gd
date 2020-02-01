extends StaticBody2D

func destruir():
	get_node("Sprite").queue_free()
	get_node("CollisionShape2D").queue_free()
	get_node("particulas").set_emitting(true)