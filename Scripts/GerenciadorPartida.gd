extends Node

signal partida_iniciada
signal partida_ganha
signal partida_perdida
signal progresso_alterado(distancia_atual: float, distancia_total: float)

@export var distancia_objetivo: float = 25000.0 
var distancia_percorrida: float = 0.0
var partida_ativa: bool = false
var partida_vencida: bool = false


func _ready() -> void:
	Engine.time_scale = 1.0


func iniciar_partida() -> void:
	distancia_percorrida = 0.0
	partida_ativa = true
	partida_iniciada.emit()

func atualizar_progresso(velocidade_atual: float, delta: float) -> void:
	if not Black_MatchManager_Ativo(): return
	distancia_percorrida += velocidade_atual * delta
	progresso_alterado.emit(distancia_percorrida, distancia_objetivo)
	
	if distancia_percorrida >= distancia_objetivo:
		vencer_partida()

func Black_MatchManager_Ativo() -> bool:
	return partida_ativa

func perder_por_morte() -> void:
	if partida_ativa:
		partida_vencida = false
		partida_ativa = false
		partida_perdida.emit()
		
func perder_por_gasolina() -> void:
	if partida_ativa:
		partida_vencida = false
		partida_ativa = false
		partida_perdida.emit()

func vencer_partida() -> void:
	partida_vencida = true
	partida_ativa = false
	partida_ganha.emit()


func pausarPartidaTermino():
	if not partida_ativa:
		Engine.time_scale = 0.0
	else:
		Engine.time_scale = 1.0
