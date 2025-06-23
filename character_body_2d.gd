# player_imperative_modular.gd
extends CharacterBody2D

var speed := 200
var run := 500
var is_runing := false

func _physics_process(delta: float) -> void:
	handle_movement()
	handle_dash()
	apply_velocity()

func handle_movement() -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_d"):
		direction.x += 1
	if Input.is_action_pressed("ui_a"):
		direction.x -= 1
	if Input.is_action_pressed("ui_s"):
		pass
	if Input.is_action_pressed("ui_w"):
		pass
	velocity = direction.normalized()

func handle_dash() -> void:
	if Input.is_action_just_pressed("ui_shift"):
		is_runing = true
	elif Input.is_action_just_released("ui_shift"):
		is_runing = false

func apply_velocity() -> void:
	velocity *= run if is_runing else speed
	move_and_slide()
