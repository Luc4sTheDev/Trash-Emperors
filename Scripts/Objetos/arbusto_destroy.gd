class_name AnimalDestroyer
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("animalrua"):
		destruirAnimal(body)


func destruirAnimal(alvo: Node2D):
	if alvo.has_method("destruirAnimal"):
		alvo.destruirAnimal()
