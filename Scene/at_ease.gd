extends Sprite2D

@export var speed = 0.25
var spawned = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawnCustomer"):
		spawnCustomer()

	if position.x <= 575 && spawned:
		position.x += delta * speed

func spawnCustomer() -> void:
	show()
	spawned = true
	
