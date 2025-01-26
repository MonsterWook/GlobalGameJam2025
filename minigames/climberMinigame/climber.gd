extends CharacterBody2D


@export var speed = 500.0
@export var jumpStrength = 500.0

@export var acceleration = 30
@export var friction = 25

var turnAroundAcceleration: float = 0

func _ready():
	turnAroundAcceleration = acceleration * 0.5

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpStrength * -1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction > 0 and velocity.x < 0:
		velocity.x = move_toward(velocity.x, direction * speed, turnAroundAcceleration)
	elif direction < 0 and velocity.x > 0:
		velocity.x = move_toward(velocity.x, direction * speed, turnAroundAcceleration)
	elif direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

	move_and_slide()
