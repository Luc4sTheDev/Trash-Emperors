extends Camera2D

@export var jogador: CharacterBody2D

@export var follow_y: bool = true
@export var follow_x: bool = false

@export var offset_camera := Vector2(0, -150)

@export var deadzone_x := 180.0
@export var deadzone_y := 120.0

@export var suavidade := 6.0

var alvo_pos: Vector2

func _ready():
	rotation_degrees = 0
	
	if is_instance_valid(jogador):
		alvo_pos = jogador.global_position + offset_camera
		global_position = alvo_pos

func _process(delta):
	if not is_instance_valid(jogador):
		return
	
	var player_pos := jogador.global_position + offset_camera
	var nova_pos := global_position
	
	if follow_y:
		var diferenca_y := player_pos.y - global_position.y
		
		if diferenca_y < -deadzone_y:
			nova_pos.y = player_pos.y + deadzone_y
		elif diferenca_y > deadzone_y:
			nova_pos.y = player_pos.y - deadzone_y
	
	if follow_x:
		var diferenca_x := player_pos.x - global_position.x
		
		if diferenca_x < -deadzone_x:
			nova_pos.x = player_pos.x + deadzone_x
		elif diferenca_x > deadzone_x:
			nova_pos.x = player_pos.x - deadzone_x
	
	global_position = global_position.lerp(nova_pos, suavidade * delta)
