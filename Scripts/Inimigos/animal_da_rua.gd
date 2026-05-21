class_name AnimalDaRua
extends CharacterBody2D

@export var speed:float = 500.0
var arbusto: Node2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	add_to_group("animalrua")
	
	arbusto = get_tree().get_first_node_in_group("arbustao")
	makepath()

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
		
	var dir = global_position.direction_to(nav_agent.get_next_path_position())
	
	velocity = dir * speed
	move_and_slide()

func makepath() -> void:
	if arbusto:
		print("detectei")
		nav_agent.target_position = arbusto.global_position

func _on_timer_timeout() -> void:
	makepath()

func destruirAnimal():
	queue_free()
