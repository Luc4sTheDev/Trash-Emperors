extends Area2D

func pegar():
	queue_free()

func inicializar(pos_inicial: Vector2) -> void:
	global_position = pos_inicial
