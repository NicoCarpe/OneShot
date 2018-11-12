extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var x = 0

signal onHit

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	$Sprite.position.y = sin(x/20)*2
	x += 1


func _on_Switch_body_entered(body):
	if body.is_in_group("Bullet"):
		emit_signal("onHit")
		$AudioStreamPlayer2D.play()
		$Sprite.texture = load("res://Tiles/switch of.png")
