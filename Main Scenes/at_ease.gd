extends Sprite2D

@export var speed = 0.25
var spawned = false

signal click(mousePos)

var speechSprite
var thoughtSprite
var cursorSprite = load("res://assets/hoverCursor.png")

var test = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	speechSprite = $"Speech"
	thoughtSprite = $"Thought"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawnCustomer"):
		spawnCustomer()

	if position.x < 0 && spawned:
		position.x += delta * speed
	if position.x >= 0 && test:
		test = false
		await get_tree().create_timer(1).timeout
		switchSpeech("res://assets/testSpeachBubble2.png")
		await get_tree().create_timer(2).timeout
		switchSpeech("res://assets/testSpeachBubble3.png")
		await get_tree().create_timer(2).timeout
		switchThought("res://assets/lockedThoughtBubble.png")
	
	if Input.is_action_just_pressed("LeftClick"):
		var thought = $Thought
		var mousePos = get_viewport().get_mouse_position()
		click.emit(mousePos)

func spawnCustomer() -> void:
	show()
	switchSpeech("res://assets/testSpeachBubble.png")
	spawned = true
func switchSpeech(newTexture):
	thoughtSprite.set_texture(null)
	speechSprite.set_texture(load(newTexture))

func switchThought(newTexture):
	speechSprite.set_texture(null)
	thoughtSprite.set_texture(load(newTexture))
