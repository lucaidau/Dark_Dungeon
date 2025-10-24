extends CharacterBody2D

const SPEED = 50.0
@onready var container: Node2D = $container
@onready var anim: AnimatedSprite2D = $container/AnimatedSprite2D
@onready var hurt_box: Area2D = $hurt_box
@onready var sight: Area2D = $sight
@onready var attack_range: Area2D = $attack_range

var is_attacking = false

var player:CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("idle")
	player = null
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_attacking:
		return
	
	if player:
		var direction = (player.global_position - self.global_position).normalized()
		velocity = direction * SPEED
		anim.play("move")
		
		if direction.x != 0:
			container.scale.x = sign(direction.x) 
	else:
		velocity = Vector2.ZERO
		anim.play("idle")
	move_and_slide()

func _on_sight_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_sight_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
