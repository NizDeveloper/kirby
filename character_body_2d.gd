extends CharacterBody2D

var velocidad = 200
var brinco = -400
var gravedad = 1000

@onready var camera = $Camera2D

func _ready():
	add_to_group("jugador")

func _physics_process(delta):
	camera.position.y = 0
	var direccion = Input.get_axis("ui_left","ui_right")
	velocity.x = direccion * velocidad
	camera.position.x = position.x
	
	if not is_on_floor():
		velocity.y += gravedad * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = brinco
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://nivel2d.tscn")
	pass # Replace with function body.
