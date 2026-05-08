class_name AnimalSpawner
extends Area2D

var animal = preload("res://inimigos/animal_da_rua.tscn")


func _on_timer_timeout() -> void:
	var animalia = animal.instantiate()
	animalia.global_position = self.global_position 
	get_parent().add_child(animalia) 
