extends Node2D

@export var cenas_para_spawnar: Array[PackedScene]
@export var jogador: Node2D

@export var tempo_minimo := 2.0
@export var tempo_maximo := 5.0

@export var faixas: Array[float] = [200.0, 400.0]

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = randf_range(tempo_minimo, tempo_maximo)
	timer.autostart = true
	timer.timeout.connect(spawnar)
	add_child(timer)

func spawnar() -> void:
	if cenas_para_spawnar.is_empty() or jogador == null:
		return

	var cena_sorteada = cenas_para_spawnar.pick_random()
	
	if cena_sorteada == null: 
		return

	var objeto = cena_sorteada.instantiate()
	get_parent().add_child.call_deferred(objeto)

	var pos_x = jogador.global_position.x + faixas.pick_random()
	var pos_spawn = Vector2(pos_x, jogador.global_position.y - 1200)

	if objeto.has_method("inicializar"):
		objeto.inicializar(pos_spawn)
	else:
		objeto.global_position = pos_spawn

	timer.wait_time = randf_range(tempo_minimo, tempo_maximo)
	timer.start()
