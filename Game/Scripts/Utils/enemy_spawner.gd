extends Node3D

@onready var enemy = preload("res://Content/Enemies/enemy.tscn")
@export var enemy_data: Enemy


func spawn() -> void:
	var ene = enemy.instantiate()
	ene.position = position
	ene.get_node("EntityComponent").initial_components = enemy_data.initial_components
	get_owner().add_child(ene)
