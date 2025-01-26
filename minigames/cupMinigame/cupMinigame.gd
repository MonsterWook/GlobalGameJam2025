extends Node2D

var correctCup: bool = false
var canClick: bool = false
var canChoose: bool = false
var cup: Node2D = null

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("spawnCustomer"):
		animation_player.play("cupGame1")
	if canChoose && Input.is_action_just_pressed("LeftClick") && canClick:
		canChoose = false
		var tween = get_tree().create_tween()
		tween.tween_property(cup, "position:y", 100, 1)
		if correctCup:
			print("correct")
		else:
			print("wrong")

func onMouseExitCup():
	canClick = false
	cup = null

func onMouseEnterCup(isCorrect:bool, enterCup:String):
	cup = get_node(enterCup)
	canClick = true
	if isCorrect:
		correctCup = true
	else:
		correctCup = false

func setCanChoose():
	canChoose = true
