class_name Caminhao_Lixo
extends CharacterBody2D

signal gas_change(new_gas: float)

var pontos: int = 0
@onready var label: Label = $"../UI/Pontuacao/Label"
@onready var reciclar: Control = $"../UI/Reciclar"
@onready var sprite_caminhao: Sprite2D = $spriteCaminhao
var tamanho_fixo = Vector2(200.0, 300.0)

@export var front_speed : float = 600.0
@export var acceleration : float = 400.0
@export var braking : float = 800.0
@export var default_speed :float = 200.0
@export var side_speed: float = 450.0

var acumulador_pontos: float = 0.0

var lixo_coletado :int = 0
var lixo_max :int = 5

@export var current_gas: float = 100.0
var gas_max: float = 100.0
var out_of_gas: bool = false

var current_speed = 0.0

var is_machucando:bool = false
var is_invencivel: bool = false
var is_in_movimento: bool = true
var podeReciclar:bool = false

@export var hurt_box: Area2D = null
var knockback_direction:= Vector2.ZERO
var knockback_strength:float = 0.0
@export var knockback_friction:float = 800.0

var lixo_atual: Area2D = null
var gasolina_atual: Area2D = null

@onready var detector_objetos: Area2D = $DetectorObjetos
@onready var icone_perigo = $Teste/IconePerigo

var perigos_no_radar := 0


func _ready() -> void:
	if InventarioGlobal.skin_atual != null:
		sprite_caminhao.texture = InventarioGlobal.skin_atual.textura_caminhao
		
		var tamanho_da_imagem = sprite_caminhao.texture.get_size()	
		sprite_caminhao.scale = tamanho_fixo / tamanho_da_imagem
		
	current_speed = move_toward(current_speed, front_speed , default_speed)
	detector_objetos.area_entered.connect(_on_gasolina_teste_area_entered)
	detector_objetos.area_entered.connect(_on_lixo_area_entered)
	
	
	label.text = " " + str(pontos)
	
	GerenciadorPartida.iniciar_partida()
	GerenciadorPartida.partida_ganha.connect(somarPontosGlobal)


func _physics_process(delta: float) -> void:
	gas_system(delta)
	movimentacao(delta)
	move_and_slide()
	reciclarLixo()
	
	GerenciadorPartida.atualizar_progresso(current_speed, delta)
	
	
func movimentacao(delta):
	if not GerenciadorPartida.partida_ativa:
		current_speed = move_toward(current_speed, 0.0, braking * delta)
		velocity.y = -current_speed
		velocity.x = 0
		is_in_movimento = false
		return

	if is_machucando:
		is_in_movimento = false
		return

	if is_in_movimento:
		acumulador_pontos += 10.0 * delta 
		if acumulador_pontos >= 1.0:
			var pontos_ganhos = int(acumulador_pontos)
			pontos += pontos_ganhos
			acumulador_pontos -= pontos_ganhos
			label.text = " " + str(pontos)

	if Input.is_action_pressed("ui_up") and not out_of_gas:
		current_speed = move_toward(current_speed, front_speed, acceleration * delta)
	elif Input.is_action_pressed("ui_down") and not out_of_gas:
		current_speed = move_toward(current_speed, 100.0 , braking * delta)
	else:
		current_speed = move_toward(current_speed, default_speed, acceleration * delta)
	if out_of_gas:
		current_speed = move_toward(current_speed, 0.0, default_speed * delta)
	velocity.y = -current_speed 
	
	var lados = Input.get_axis("ui_left", "ui_right")
	if current_speed > 10:
		velocity.x = lados * side_speed
	else:
		velocity.x = 0.0
		
func gas_system(delta):
	if not GerenciadorPartida.partida_ativa: 
		return

	current_gas -= 2.5 * delta
	gas_change.emit(current_gas)
	if current_gas <= 0 and not out_of_gas:
		current_gas = 0
		out_of_gas = true
		GerenciadorPartida.perder_por_gasolina()
	

func _on_gasolina_teste_area_entered(area: Area2D) -> void:
	if area.is_in_group("gasolina"):
		print("gasolina detectada")
		gasolina_atual = area
		gasolina_atual.pegar()
		current_gas += 20.0
		current_gas = clamp(current_gas, 0, gas_max)
		gas_change.emit(current_gas)


func _on_lixo_area_entered(area: Area2D) -> void:
	if lixo_coletado >= lixo_max:
		print("lotado, precisa reciclar")
		return

	if area.is_in_group("lixo"):
		lixo_atual = area
		lixo_atual.destruir()
		lixo_coletado += 1
		pontos += 100
		label.text = " " + str(pontos)

func reciclarLixo():
	if lixo_coletado >= lixo_max:
		podeReciclar = true
		reciclar.show()
	else:
		podeReciclar = false
		reciclar.hide()
	
	if Input.is_action_just_pressed("reciclar") and podeReciclar:
		lixo_coletado = 0
		pontos *= 2
		label.text = " " + str(pontos)

func morrer():
	GerenciadorPartida.perder_por_morte()

func somarPontosGlobal():
	if not GerenciadorPartida.partida_ativa and GerenciadorPartida.partida_vencida:
		PontosGlobal.add_points(pontos)
		print("Pontuacao ", PontosGlobal.get_points())

func _on_sensor_perigo_body_entered(body):
	if body.is_in_group("inimigos"):
		perigos_no_radar += 1
		icone_perigo.visible = true

func _on_sensor_perigo_body_exited(body):
	if body.is_in_group("inimigos"):
		perigos_no_radar -= 1
		
		if perigos_no_radar <= 0:
			perigos_no_radar = 0
			icone_perigo.visible = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is obstaculos_tenebrosos:
		morrer()
		return 

	var atacante = area.owner
	if atacante is carro_transito and atacante != self:
		if "Hitbox" in area.name:
			morrer()
