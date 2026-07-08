extends Node2D

@onready var medidor_distancia: TextureProgressBar = $UI/Minimapa/ProgressBar
@onready var tela_vitoria: Control = $UI/TelaVitoria
@onready var perdeu_batendos: Control = $UI/PerdeuBatendo
@onready var perdeu_por_gasolina: Control = $UI/PerdeuPorGasolina
@onready var mensagem_vitoria: Label = $UI/TelaVitoria/MensagemVitoria
@onready var reiniciar: Button = $UI/Reiniciar
@onready var voltar_ao_menu: Button = $UI/VoltarAoMenu


func _ready() -> void:
	GerenciadorPartida.progresso_alterado.connect(_on_progresso_alterado)
	GerenciadorPartida.partida_ganha.connect(_on_partida_ganha)
	GerenciadorPartida.partida_perdida.connect(_on_partida_perdida)
	reiniciar.pressed.connect(_on_reiniciar_pressed)
	voltar_ao_menu.pressed.connect(_on_menu_backPressed)

	tela_vitoria.hide()
	perdeu_batendos.hide()
	perdeu_por_gasolina
	reiniciar.hide()
	voltar_ao_menu.hide()
	print(" A raiz da Fase carregou")
func _on_progresso_alterado(dist_atual: float, dist_total: float) -> void:
	medidor_distancia.max_value = dist_total
	medidor_distancia.value = dist_atual

func _on_partida_ganha() -> void:
	tela_vitoria.show()
	voltar_ao_menu.show()
	await get_tree().process_frame 
	Engine.time_scale = 0.0
	mensagem_vitoria.text = "Você venceu!\nPontos: " + str(PontosGlobal.get_points())

func _on_partida_perdida() -> void:
	if GerenciadorPartida.perdeu_batendo:
		perdeu_batendos.show()
	if GerenciadorPartida.perdeuGasolina:
		perdeu_por_gasolina.show()
		
	reiniciar.show()
	Engine.time_scale = 0.0
	
func _on_reiniciar_pressed():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_menu_backPressed():
	get_tree().change_scene_to_file("res://Cenas/Main Menu/selecao_fase.tscn")
