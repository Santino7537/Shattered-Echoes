extends Node3D

var MAX_LIGHTS: int = 64
var light_image: Image
var light_texture: ImageTexture

@onready var player = $Player


func _ready() -> void:
	light_image = Image.create(MAX_LIGHTS, 1, false, Image.FORMAT_RGBAF)
	light_texture = ImageTexture.create_from_image(light_image)
	RenderingServer.global_shader_parameter_set("color_lights_tex", light_texture)
	RenderingServer.global_shader_parameter_set("color_light_count", 0)
	
	for enemy_mesh in get_tree().get_nodes_in_group("enemies"):
		var mat: ShaderMaterial = ShaderMaterial.new()
		mat.shader = preload("res://Assets/Shaders/Illumination/color_reveal_lighting.gdshader")
		mat.set_shader_parameter("albedo_texture", preload("res://Testing/Color_Reveal_Lighting/color_red.png"))
		enemy_mesh.get_node("MeshInstance3D").material_override = mat
	
	await get_tree().create_timer(3.0).timeout
	for enemy in get_node("Enemies").get_children():
		enemy.spawn()

func _process(_delta: float) -> void:
	var lights: Array[Node] = get_tree().get_nodes_in_group("color_revealer")
	var count: int = min(lights.size(), MAX_LIGHTS)
	
	for i in count:
		var l = lights[i] as OmniLight3D
		var pos = l.global_position
		light_image.set_pixel(i, 0, Color(pos.x, pos.y, pos.z, l.omni_range))
	
	for i in range(count, MAX_LIGHTS):
		light_image.set_pixel(i, 0, Color(0, -9999, 0, 0))
	
	light_texture.update(light_image)
	RenderingServer.global_shader_parameter_set("color_lights_tex", light_texture)
	RenderingServer.global_shader_parameter_set("color_light_count", count)
