extends Node3D

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	for enemy in get_node("Enemies").get_children():
		enemy.spawn()
