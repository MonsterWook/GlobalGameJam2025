extends Sprite2D

var speechSprite
var leave = false
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speechSprite = $Speech
	dialogue(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if leave:
		if position.x >= -333:
			position.x -= delta * speed
		else:
			hide()

func dialogue(dialogueNumber):
	match(dialogueNumber):
		0:
			speechSprite.set_texture(load("res://assets/officeGuyLeavingSpeechBubble1.png"))
			await get_tree().create_timer(2).timeout
			dialogue(1)
		1:
			speechSprite.position = Vector2(270, 133)
			speechSprite.set_texture(load("res://assets/officeGuyLeavingSpeechBubble2.png"))
			await get_tree().create_timer(2).timeout
			dialogue(2)
		2:
			speechSprite.position = Vector2(99.629, -154.319)
			speechSprite.set_texture(load("res://assets/officeGuyLeavingSpeechBubble3.png"))
			await get_tree().create_timer(1).timeout
			leave = true
