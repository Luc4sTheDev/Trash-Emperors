extends Node2D

@export var cena_inimigo: PackedScene
@export var jogador: Node2D
@export var tempo_spawn := 2.0

@export var faixas: Array[float] = [200.0, 400.0]

func _ready():
	var timer = Timer.new()
	timer.wait_time = tempo_spawn
	timer.autostart = true
	timer.timeout.connect(spawnar)
	add_child(timer)
	spawnar()

func spawnar():
	if cena_inimigo == null or jogador == null:
		return

	var inimigo = cena_inimigo.instantiate()
	get_parent().add_child.call_deferred(inimigo)

	var pos_x = jogador.global_position.x + faixas.pick_random()
	var pos_spawn = Vector2(pos_x, jogador.global_position.y - 800)
	var tipo = randi() % 2

	inimigo.inicializar(jogador, pos_spawn, tipo)
