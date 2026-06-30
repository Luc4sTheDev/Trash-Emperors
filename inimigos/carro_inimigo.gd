extends CharacterBody2D

enum TipoComportamento {
	VAI_RETO,
	FECHA_JOGADOR
}

@export var velocidade := 250.0
@export var velocidade_lateral := 120.0

var comportamento: TipoComportamento
var jogador: Node2D = null
var alvo_x := 0.0
var mudando_faixa := false

@onready var ray_esquerda = $RaycastDireita
@onready var ray_direita = $RaycastEsquerda

func inicializar(ref_jogador: Node2D, pos_inicial: Vector2, tipo_escolhido: TipoComportamento):
	jogador = ref_jogador
	global_position = pos_inicial
	comportamento = tipo_escolhido
	alvo_x = pos_inicial.x

func _ready():
	z_index = 100
	add_to_group("inimigos")

func _physics_process(delta):
	if jogador == null:
		return

	velocity.y = -velocidade

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
			if colisor.is_in_group("parede") or colisor.is_in_group("inimigo"):
				return true
	return false
