extends SubViewport

@onready var minimap_cam: Camera2D = $minimapCam


func _physics_process(delta: float) -> void:
	minimap_cam.position = owner.find_child("CaminhaoTeste").position
