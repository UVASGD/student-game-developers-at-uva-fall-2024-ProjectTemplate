extends Node2D

@export var button1: Button
@export var button2: Button
@export var button3: Button
@export var button4: Button
@export var submit: Button

@export var sprite1: Sprite2D
@export var sprite2: Sprite2D
@export var sprite3: Sprite2D
@export var sprite4: Sprite2D

var player1Char = 0
var player2Char = 0
var player3Char = 0
var player4Char = 0

var characters = ["Frankenstein","Pumpkin", "Witch", "Ghost"]

func onButton1Press():
	if(player1Char == 3):
		player1Char = 0
	else:
		player1Char += 1
	sprite1.frame = player1Char
	button1.text = characters[player1Char]
	
func onButton2Press():
	if(player2Char == 3):
		player2Char = 0
	else:
		player2Char += 1
	sprite2.frame = player2Char
	button2.text = characters[player2Char]
	
func onButton3Press():
	if(player3Char == 3):
		player3Char = 0
	else:
		player3Char += 1
	sprite3.frame = player3Char
	button3.text = characters[player3Char]
	
func onButton4Press():
	if(player4Char == 3):
		player4Char = 0
	else:
		player4Char += 1
	sprite4.frame = player4Char
	button4.text = characters[player4Char]
	
	

func _ready():
	button1.connect("pressed", onButton1Press)
	button2.connect("pressed", onButton2Press)
	button3.connect("pressed", onButton3Press)
	button4.connect("pressed", onButton4Press)
	submit.connect("pressed", getPlayerRoles)
	

func getPlayerRoles() -> Array[int]:
	var intArray = []
	intArray.append(player1Char)
	intArray.append(player2Char)
	intArray.append(player3Char)
	intArray.append(player4Char)
	return intArray
	
	
