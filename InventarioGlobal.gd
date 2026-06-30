extends Node

@export var skin_atual: SkinData 

func equipar_skin(nova_skin: SkinData) -> void:
	if nova_skin.esta_desbloqueada:
		skin_atual = nova_skin
		print("equipou")
