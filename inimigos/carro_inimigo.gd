extends CharacterBody2D
class_name carro_transito

enum TipoComportamento {
	VAI_RETO,
	FECHA_JOGADOR
}

@export var velocidade := 250.0
@export var velocidade_lateral := 120.0
@export var margem_parede := 25.0 

var comportamento: TipoComportamento
var jogador: Node2D = null
var alvo_x := 0.0
var mudando_faixa := false

@onready var ray_esquerda = $RaycastEsquerda
@onready var ray_direita = $RaycastDireita
@onready var detector_de_carro: Area2D = $DetectorDeCarro
@onready var balao_fala: PanelContainer = $"balaodefala"

func inicializar(ref_jogador: Node2D, pos_inicial: Vector2, tipo_escolhido: TipoComportamento):
	jogador = ref_jogador
	global_position = pos_inicial
	comportamento = tipo_escolhido
	alvo_x = pos_inicial.x
	


func _ready():
	z_index = 100
	add_to_group("inimigos")
	verificar_gatilho_de_fala()
func _physics_process(delta):
	if jogador == null:
		return

	var aceleracao_fuga = 0.0
	var carros_proximos = detector_de_carro.get_overlapping_bodies()
	
	for outro_carro in carros_proximos:
		
		if outro_carro != self and outro_carro.is_in_group("inimigos"):
			if outro_carro.global_position.y > global_position.y:
				aceleracao_fuga = 150.0
				break 
	velocity.y = -(velocidade + aceleracao_fuga)

	if comportamento == TipoComportamento.FECHA_JOGADOR and not mudando_faixa:
		var distancia_y = jogador.global_position.y - global_position.y
		
		if distancia_y > 0 and distancia_y < 400:
			alvo_x = jogador.global_position.x
			mudando_faixa = true 

	if mudando_faixa:
		var diferenca = alvo_x - global_position.x
		
		if abs(diferenca) > 5.0:
			var direcao = sign(diferenca)
			
			if direcao < 0 and verificar_obstaculo(ray_esquerda):
				velocity.x = 0
				mudando_faixa = false 
				
			elif direcao > 0 and verificar_obstaculo(ray_direita):
				velocity.x = 0
				mudando_faixa = false
				
			else:
				velocity.x = direcao * velocidade_lateral
		else:
			velocity.x = 0
			mudando_faixa = false
			global_position.x = alvo_x
	else:
		velocity.x = 0

	move_and_slide()

	if global_position.y > jogador.global_position.y + 1200:
		queue_free()

func verificar_obstaculo(raycast: RayCast2D) -> bool:
	if raycast.is_colliding():
		var colisor = raycast.get_collider()
		if colisor:
			if colisor.is_in_group("Parede"):
				var ponto_colisao = raycast.get_collision_point()
				var distancia_da_parede = abs(global_position.x - ponto_colisao.x)
				
				if distancia_da_parede <= margem_parede:
					return true
				else:
					return false 
					
			elif colisor.is_in_group("inimigos"):
				return true 
	return false
	
func verificar_gatilho_de_fala() -> void:
	if GerenciadorPartida.nome_da_fase_atual == "Santo Antônio":
		if not GerenciadorPartida.balao_ja_foi_exibido:
			if randf() < 0.7:
				GerenciadorPartida.balao_ja_foi_exibido = true
				exibir_balao()

func exibir_balao() -> void:
	balao_fala.show()
	get_tree().create_timer(3.0).timeout.connect(esconder_balao)

func esconder_balao() -> void:
	balao_fala.hide()
	
	
