extends RichTextLabel

signal changeScene

@export var randomTexts: Array[String] = ["Make More Text Prompts!"]
var textToBeTyped: String = ""
var currentChar: int = 0

var typedText: String = ""
var isWrong: bool = false
var gameFinished: bool = false

@onready var bg = $"../BG"

# Called when the node enters the scene tree for the first time.
func _ready():
	textToBeTyped = randomTexts.pick_random()
	text = textToBeTyped

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "[center][color=black]%s[/color][color=#c7c7c7]%s[/color][/center]" % [typedText.substr(0, currentChar), textToBeTyped.substr(currentChar)]
	if currentChar >= textToBeTyped.length() && !gameFinished:
		gameFinished = true
		bg.play("Finished")
		
		await get_tree().create_timer(2).timeout
		changeScene.emit()

func _unhandled_input(event):
	if isWrong or currentChar >= textToBeTyped.length():
		return

	var nextChar = textToBeTyped.unicode_at(currentChar)
	if event is InputEventKey:
		if event.unicode == 0:
			return
		if event.pressed and event.unicode == nextChar:
			print("Correct")
			typeLetter()
		elif event.pressed and event.unicode != nextChar:
			print("pressed: " + str(event.unicode))
			print("expected: " + str(nextChar))
			failLetter()

func typeLetter():
	typedText += textToBeTyped[currentChar]
	currentChar += 1
	
func failLetter():
	bg.play("Wrong")
	isWrong = true
	await get_tree().create_timer(1).timeout
	
	isWrong = false
	bg.play("Default")
	
	
	 
