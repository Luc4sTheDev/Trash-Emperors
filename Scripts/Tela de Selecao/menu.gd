extends CanvasLayer


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Main Menu/selecao_fase.tscn")


func _on_loja_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Main Menu/seletor_caminhao.tscn")
