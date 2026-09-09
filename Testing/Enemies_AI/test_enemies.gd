extends Node3D

@onready var player = $Player

func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	for enemy in get_node("Enemies").get_children():
		enemy.spawn()
