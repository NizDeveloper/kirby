# Kirby

 ## Integrantes
 - Níz Gadiel Peña Mariscal
 - Maximo Santiago Romero 
   
## Mecanicas
Es un juego de aventura en las plataformas es un juego 2D clásico de plataformas donde controlas a Kirby, quien debe saltar entre plataformas, recolectar monedas y llegar a la meta para avanzar al siguiente nivel.

## Recursos Usados
Todos los assets fueron descargados de <a href="https://www.spriters-resource.com/game_boy_advance/kirbynim/">Spriters Resource</a>
Sprites de Kirby, Fondo para los niveles y el diseño del mapa.

## Escenas
  - Nivel 1:
    Es un ambiente colorido con pasto brillante, el nivel tiene una plataforma frágil que se rompe despues de pisarla y al final una plataforma de rebote, que cuando lo toca sale impulsado por el aire
    
  - Nivel 2:
    Esta ambientado en una montaña en las nubes, donde hay una plataforma fantasma que aparece y desaparece, una plataforma oscilatoria que se mueve de lado a lado, una plataforma fragil que se rompe cuando la pisas y la ultima que 

## Códigos
### kirby.gd
```gdscript
extends CharacterBody2D

# Variables del personaje
var velocidad = 60       # Velocidad horizontal normal
var brinco = -300        # Fuerza del salto (negativo porque en Godot el eje Y va hacia abajo)
var gravedad = 1000      # Fuerza de gravedad aplicada
var puntuacion = 0       # Contador de monedas recolectadas
var run = false          # Bandera para estado de carrera (no se usa actualmente)

# Referencias a nodos hijos
@onready var anim_player = $AnimationPlayer  # Controlador de animaciones
@onready var sprite = $Sprite2D              # Sprite visual del personaje
@onready var puntuacion_label = $puntuacion  # Label para mostrar puntuación
@onready var label = $Label                  # Label adicional (no se usa actualmente)
@onready var coin = $"../coin"               # Primera moneda en el nivel
@onready var coin2 = $"../coin2"             # Segunda moneda en el nivel
@onready var coin3 = $"../coin3"             # Tercera moneda en el nivel

func _ready():
    add_to_group("jugador")  # Agrega el personaje al grupo "jugador"
    moneda()                 # Inicializa el sistema de monedas

func _physics_process(delta):
    # Movimiento horizontal
    var direccion = Input.get_axis("ui_left","ui_right")  # -1 (izq), 0 (ninguna), 1 (der)
    
    # Lógica de movimiento y animaciones
    if Input.is_action_pressed("ui_shift"):  # Correr (tecla Shift)
        velocity.x = (direccion * velocidad) * 2  # Doble velocidad
        anim_player.play("run")                   # Animación de correr
    else:
        velocity.x = direccion * velocidad  # Velocidad normal
        anim_player.play("walk")            # Animación de caminar
    
    # Animación de estar quieto
    if velocity.x == 0:
        anim_player.play("idle")
    
    # Voltear sprite según dirección
    if Input.is_action_pressed("ui_right"):
        sprite.flip_h = false  # Mira a la derecha
        
    if Input.is_action_pressed("ui_left"):
        sprite.flip_h = true   # Mira a la izquierda

    # Animación de agacharse
    if Input.is_action_pressed("ui_down"):
        anim_player.play("bend")

    # Aplicar gravedad
    if not is_on_floor():
        velocity.y += gravedad * delta  # Aplica gravedad frame por frame
        anim_player.play("fall")        # Animación de caída

    # Lógica de salto
    if Input.is_action_just_pressed("ui_up") and is_on_floor():
        velocity.y = brinco  # Aplica fuerza de salto

    move_and_slide()  # Método de Godot para mover el personaje con colisiones

    # Verificación de monedas (duplicada, podría optimizarse)
    moneda()
    move_and_slide()

# Función para recolectar monedas
func moneda():
    # Verifica colisión con cada moneda y las "recoge"
    if coin.overlaps_body(self):
        coin.position.y = -1000  # Mueve la moneda fuera de pantalla
        puntuacion += 1          # Incrementa puntuación
        puntuacion_label.text = str(puntuacion)  # Actualiza el marcador
        
    if coin2.overlaps_body(self):
        coin2.position.y = -1000
        puntuacion += 1
        puntuacion_label.text = str(puntuacion)
        
    if coin3.overlaps_body(self):
        coin3.position.y = -1000
        puntuacion += 1
        puntuacion_label.text = str(puntuacion)

# Función que se ejecuta al tocar un área de muerte
func _on_area_2d_body_entered(body: Node2D) -> void:
    get_tree().reload_current_scene()  # Reinicia el nivel actual
    pass

# Función que se ejecuta al tocar un área de cambio de nivel
func _on_area_2d_2_body_entered(body: Node2D) -> void:
    get_tree().change_scene_to_file("res://nivel2d.tscn")  # Carga el nivel 2
    pass
```

---
### plataforma.gd
```gdscript
extends Area2D

# Enumeración de tipos de plataformas disponibles
enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE, PARPADEANTE}

# Variables exportables (editables en el editor de Godot)
@export var tipo: TipoPlataforma = TipoPlataforma.FIJA  # Tipo de plataforma (por defecto FIJA)
@export var fuerza_rebote := 2.0  # Multiplicador de fuerza para plataformas de rebote

func _ready():
    # Inicialización
    actualizar_plataforma()  # Configura la apariencia y comportamiento según el tipo
    monitorable = true  # Permite que otras áreas detecten esta plataforma
    monitoring = true   # Permite que esta plataforma detecte otros cuerpos

# Actualiza las propiedades visuales y físicas según el tipo de plataforma
func actualizar_plataforma():
    match tipo:
        TipoPlataforma.FIJA:
            $Sprite2D.modulate = Color.GREEN  # Plataforma estándar (verde)
        
        TipoPlataforma.OSCILATORIA:
            $Sprite2D.modulate = Color.BLUE  # Plataforma móvil (azul)
            oscilar()  # Inicia movimiento oscilatorio
        
        TipoPlataforma.FRAGIL:
            $Sprite2D.modulate = Color.RED  # Plataforma que se rompe (roja)
        
        TipoPlataforma.REBOTE:
            $Sprite2D.modulate = Color.YELLOW  # Plataforma con rebote (amarilla)
        
        TipoPlataforma.PARPADEANTE:
            $Sprite2D.modulate = Color.MAGENTA  # Plataforma que parpadea (magenta)
            parpadear()  # Inicia efecto de parpadeo

# Detecta cuando un cuerpo entra en la plataforma
func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("jugador"):  # Solo reacciona al jugador
        match tipo:
            TipoPlataforma.FRAGIL:
                # Plataforma que se destruye después de 0.5 segundos
                await get_tree().create_timer(0.5).timeout
                queue_free()  # Elimina la plataforma
            
            TipoPlataforma.REBOTE:
                # Plataforma que impulsa al jugador hacia arriba
                if body.has_method("puede_rebotar"):
                    body.puede_rebotar(fuerza_rebote)  # Llama a método personalizado
                else:
                    # Implementación básica de rebote
                    body.velocity.y = body.brinco * fuerza_rebote

# Movimiento oscilatorio lateral (izquierda-derecha)
func oscilar():
    var tween = create_tween()  # Crea animación suave
    tween.tween_property(self, "position:x", position.x + 100, 2)  # Mueve derecha
    tween.tween_property(self, "position:x", position.x - 100, 2)  # Mueve izquierda
    tween.set_loops()  # Repite infinitamente

# Efecto de plataforma que aparece/desaparece
func parpadear():
    while true:  # Bucle infinito
        await get_tree().create_timer(2).timeout
        $Sprite2D.visible = false  # Oculta sprite
        $StaticBody2D/CollisionShape2D.disabled = true  # Desactiva colisión
        
        await get_tree().create_timer(2).timeout
        $Sprite2D.visible = true   # Muestra sprite
        $StaticBody2D/CollisionShape2D.disabled = false  # Reactiva colisión

# Reinicia el nivel al tocar un área de muerte (conectada a señal)
func _on_area_2d_body_entered(body: Node2D) -> void:
    get_tree().reload_current_scene()  # Recarga escena actual

# Cambia al nivel 2 al tocar un área de victoria (conectada a señal)
func _on_area_2d_2_body_entered(body: Node2D) -> void:
    get_tree().change_scene_to_file("res://nivel2d.tscn")  # Carga nueva escena
```

## Dificultades usando GitHub
### Níz
Yo ya sabía el uso de git y github, el problema que tuve fue el coordinar y "enseñar" a usar git a mi compañero.

### Maximo
Tuve problemas en:
- modifican el mismo archivo línea de código, y al intentar fusionar ramas
- Al hacer push, puedes subir cambios que eliminan los de otro compañero si no hiciste pull antes
y las cosecuensias fue que algunas vezes se perdio trabajo, y es difícil recuperarlo si no hay respaldos
y algunas veze se debia resolver el conflicto manualmente, lo que puede ser difícil.

## Conclusión
En la programación es muy importante usar las herramientas colaborativas para el trabajo en equipo, ambos pudimos trabajar en diferentes partes del juego y tuvimos que combinar nuestros códigos a través de Git para hacerlo funcionar, tuvimos algunos conflictos de código pero juntos tuvimos que organizarnos y hablar para resolverlos.
