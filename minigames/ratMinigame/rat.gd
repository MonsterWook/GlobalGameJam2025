extends CharacterBody2D

@export var speed = 150
@export var rotation_speed = 4

var rotation_direction = 0


func get_input():
	rotation_direction = Input.get_axis("Left", "Right")
	velocity = transform.x * Input.get_axis("Up", "Down") * speed

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
