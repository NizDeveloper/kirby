extends CharacterBody2D

var velocidad = 60
var brinco = -300
var gravedad = 1000
var run = false

@onready var anim_player = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	add_to_group("jugador")

func _physics_process(delta):
	var direccion = Input.get_axis("ui_left","ui_right")
	
	if Input.is_action_pressed("ui_shift"):
		velocity.x = (direccion * velocidad) * 2
		anim_player.play("run")
	else:
		velocity.x = direccion * velocidad
		anim_player.play("walk")
	
	if velocity.x == 0:
		anim_player.play("idle")
	
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
	
	if Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		
	if Input.is_action_pressed("ui_down"):
		anim_player.play("bend")
	
	if not is_on_floor():
		velocity.y += gravedad * delta
		anim_player.play("fall")
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = brinco
	
	move_and_slide()

	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = brinco
	
	move_and_slide()
