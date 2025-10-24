extends CharacterBody2D


const SPEED = 100.0
@onready var container: Node2D = $container
@onready var anim: AnimatedSprite2D = $container/AnimatedSprite2D
@onready var attack_range: Area2D = $attack_range

var is_attack = false
var can_attack = true

func _ready() -> void:
	attack_range.monitoring = false

func _physics_process(delta: float) -> void:
	if can_attack and Input.is_action_just_pressed("attack"):
		attack()
	if is_attack:
		return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = input_vector * SPEED
		anim.play("walk")
		if input_vector.x != 0:
			container.scale.x = sign(input_vector.x) 
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		anim.play("idle")
	move_and_slide()

func attack() -> void:
	if can_attack and not is_attack:
		is_attack = true
		can_attack = false	
		anim.play("attack")
		attack_range.monitoring = true	
		await anim.animation_finished
		attack_range.monitoring = false	
		is_attack = false
		can_attack = true
