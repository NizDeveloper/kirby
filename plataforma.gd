extends Area2D
enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE, PARPADEANTE}
@export var tipo: TipoPlataforma = TipoPlataforma.FIJA;
@export var fuerza_rebote := 2.0

func _ready():
	actualizar_plataforma()
	monitorable = true
	monitoring = true
	
func actualizar_plataforma():
	match tipo:
		TipoPlataforma.FIJA:
			$Sprite2D.modulate = Color.GREEN
		TipoPlataforma.OSCILATORIA:
			$Sprite2D.modulate = Color.BLUE
			oscilar()
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color.RED
		TipoPlataforma.REBOTE:
			$Sprite2D.modulate = Color.YELLOW
		TipoPlataforma.PARPADEANTE:
			$Sprite2D.modulate = Color.MAGENTA
			parpadear()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
	
		match tipo:
			TipoPlataforma.FRAGIL:
				await get_tree().create_timer(0.5).timeout
				queue_free()
			TipoPlataforma.REBOTE:
				if body.has_method("puede_rebotar"):
					body.puede_rebotar(fuerza_rebote)
				else:
					body.velocity.y = body.brinco * fuerza_rebote

func oscilar():
		var tween = create_tween()
		tween.tween_property(self,"position:x",position.x + 100,2)
		tween.tween_property(self,"position:x",position.x - 100,2)
		tween.set_loops()
func parpadear():
	while true:
		await get_tree().create_timer(2).timeout
		$Sprite2D.visible = false
		$StaticBody2D/CollisionShape2D.disabled = true
		await get_tree().create_timer(2).timeout
		$Sprite2D.visible = true
		$StaticBody2D/CollisionShape2D.disabled = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://nivel2d.tscn")
	pass # Replace with function body.
