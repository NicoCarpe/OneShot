extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var MOTION_SPEED = 50

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	var movedir = Vector2(1,0).rotated(rotation)
	var motion = movedir.normalized() * MOTION_SPEED
	move_and_slide(motion)