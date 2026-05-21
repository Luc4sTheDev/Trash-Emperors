class_name Caminhao_Lixo
extends CharacterBody2D

signal gas_change(new_gas: float)

var pontos = 0
@onready var label: Label = $"../UI/Pontuacao/Label"

@export var life_count = 3

@export var steering_angle := 15.0
@export var engine_power := 900.0
@export var brake_force := 1200.0

@export var forcaLerdao: float = 500.0

@export var friction := 0.98
@export var drag := 0.995

var steer_direction := 0.0

var gas_max: float = 100.0
@export var current_gas: float = 100.0

var out_of_gas :bool = false
var pode_abastecer :bool = false
var abastecendo :bool = false
var is_reciclando = false
var is_machucando:bool = false
var is_invencivel:bool = false


var lixo_coletado :int = 0
var lixo_max :int = 2
var vida:int = 3

@export var hurt_box:Area2D = null

var knockback_direction:= Vector2.ZERO
var knockback_strength:float = 0.0
@export var knockback_friction:float = 800.0

var lixo_atual: Area2D = null

@onready var interagir: Control = $"../UI/Interact"
@onready var detector_lixo: Area2D = $DetectorLixo
@onready var reciclar: Control = $"../UI/Reciclar"


func _ready():
	detector_lixo.area_entered.connect(_on_lixo_area_entered)
	detector_lixo.area_exited.connect(_on_lixo_area_exited)
	label.text = "0"

func _physics_process(delta):
	handle_input(delta)
	apply_friction()
	reabastecendo(delta)
	gas_system(delta)
	coletar_lixo()
	calculate_steering(delta)
	reclicando()
	
	if knockback_strength > 0:
		velocity += knockback_direction * knockback_strength
		knockback_strength = move_toward(knockback_strength, 0.0, knockback_friction * delta)
	move_and_slide()

func gas_system(delta):
	if current_gas <= 0:
		current_gas = 0
		out_of_gas = true

	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		current_gas -= 1.0 * delta
		gas_change.emit(current_gas)

func handle_input(delta):
	if is_machucando:
		return

	var acceleration = Vector2.ZERO

	var turn = Input.get_axis("ui_left", "ui_right")
	steer_direction = turn * deg_to_rad(steering_angle)

	var forward_speed = velocity.dot(transform.x)

	var proporcao_peso = float(lixo_coletado) / float(lixo_max)
	proporcao_peso = clamp(proporcao_peso, 0.0, 1.0)
	var current_power = lerp(engine_power, forcaLerdao, proporcao_peso)

	if Input.is_action_pressed("ui_up") and not out_of_gas:
		acceleration = transform.x * current_power

	elif Input.is_action_pressed("ui_down") and not out_of_gas:
		if forward_speed > 5:
			acceleration = -transform.x * brake_force
		else:
			acceleration = -transform.x * current_power * 0.6
			
	velocity += acceleration * delta

func reclicando():
	var is_parado = velocity.length() < 5
	
	if is_parado and lixo_coletado >= lixo_max:
		reciclar.show()
		if Input.is_action_just_pressed("reciclar"):
			velocity = Vector2.ZERO
			lixo_coletado = 0
			pontos *= 2
			label.text = " " + str(pontos)
	else:
		reciclar.hide()

func apply_friction():
	velocity *= drag
	velocity *= friction

	if velocity.length() < 5:
		velocity = Vector2.ZERO


func calculate_steering(delta):
	if is_machucando:
		return
	var forward_speed = velocity.dot(transform.x)

	if abs(forward_speed) < 1:
		return

	var turn = steer_direction

	if forward_speed < 0:
		turn *= -1

	rotation += turn * (abs(forward_speed / 100.0)) * delta
	velocity = transform.x * forward_speed

func reabastecendo(delta):
	if pode_abastecer and Input.is_action_pressed("interact"):
		abastecendo = true
	else:
		abastecendo = false

	if abastecendo:
		current_gas += 10.0 * delta
		current_gas = clamp(current_gas, 0, gas_max)
		velocity = Vector2.ZERO
		gas_change.emit(current_gas)

func coletar_lixo():
	if Input.is_action_just_pressed("interact") and lixo_atual and lixo_coletado < lixo_max:
		lixo_coletado += 1
		pontos += 50
		print("Lixo coletado: ", lixo_coletado)
		label.text = " " + str(pontos)
		velocity = Vector2.ZERO
		lixo_atual.destruir()
	
func takeDamage(amount: int):
	if is_invencivel:
		return
	vida -= amount
	if vida <= 0:
		die()
		return

	is_machucando = true
	is_invencivel = true
	velocity = Vector2.ZERO
	print("Tomou Dano")
	var tween = create_tween()
	tween.set_loops(15) 
	tween.tween_property(self, "modulate:a", 0.0, 0.1) 
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	await get_tree().create_timer(2.0).timeout
	is_machucando = false
	await get_tree().create_timer(1.0).timeout
	is_invencivel = false
	

func die():
	set_physics_process(false)

func knockback(attacker_global_position: Vector2, hit_strength: float):
	knockback_direction = (global_position - attacker_global_position).normalized()
	knockback_strength = hit_strength

func _on_lixo_area_entered(area):
	if area.is_in_group("lixo"):
		lixo_atual = area
		interagir.show()

func _on_lixo_area_exited(area):
	if area == lixo_atual:
		lixo_atual = null
		interagir.hide()

func _on_posto_de_gasolina_body_entered(body):
	if current_gas < gas_max:
		pode_abastecer = true
		interagir.show()


func _on_posto_de_gasolina_body_exited(body):
	pode_abastecer = false
	interagir.hide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var dano = area.owner
	if dano is AnimalDaRua and dano != self:
		if "Hitbox" in area.name:
			takeDamage(1)
			knockback(dano.global_position, 200.0)
