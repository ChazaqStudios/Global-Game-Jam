extends Control

var loader
var wait_frames
var time_max = 100 # msec
var current_scene


func _on_Iniciar_pressed():
	get_tree().change_scene("res://scenes/Fase.tscn")


func _on_Config_pressed():
	pass # Replace with function body.


func _on_Creditos_pressed():
	pass # Replace with function body.


func _on_Sair_pressed():
	get_tree().quit()
