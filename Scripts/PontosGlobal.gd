extends Node

signal points_updated(new_points)

var current_points: int = 0

func add_points(amount: int):
	current_points += amount
	points_updated.emit(current_points)

func spend_points(spend: int):
	if current_points >= spend:
		current_points =- spend
		points_updated.emit(current_points)
	else:
		print("N pode comprar")

func get_points():
	return current_points
	
	
func tentar_comprarFase(fase: FaseData):
	if fase.esta_desbloqueada:
		return true
	if current_points >= fase.preco:
		spend_points(fase.preco)
		fase.esta_desbloqueada = true
		return true
	else:
		return false
