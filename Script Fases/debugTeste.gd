extends Node2D

@onready var medidor_distancia: ProgressBar = $UI/Minimapa/ProgressBar
@onready var tela_vitoria: Control = $UI/TelaVitoria
@onready var tela_derrota: Control = $UI/TelaDerrota
@onready var mensagem_vitoria: Label = $UI/TelaVitoria/MensagemVitoria

func _ready() -> void:
	GerenciadorPartida.progresso_alterado.connect(_on_progresso_alterado)
	GerenciadorPartida.partida_ganha.connect(_on_partida_ganha)
	GerenciadorPartida.partida_perdida.connect(_on_partida_perdida)
	
	tela_vitoria.hide()
	tela_derrota.hide()

func _on_progresso_alterado(dist_atual: float, dist_total: float) -> void:
	medidor_distancia.max_value = dist_total
	medidor_distancia.value = dist_atual

func _on_partida_ganha() -> void:
	tela_vitoria.show()
	await get_tree().process_frame 
	mensagem_vitoria.text = "Você venceu!\nPontos: " + str(PontosGlobal.get_points())

func _on_partida_perdida() -> void:
	tela_derrota.show()
