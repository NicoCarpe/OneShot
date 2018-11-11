extends KinematicBody2D

export var NORMAL_SPEED = 500
var WITH_BULLET_SPEED = 200
var MOTION_SPEED = NORMAL_SPEED
#onready var SpriteNode = get_node("Sprite")
onready var AnimNode = get_node("AnimationPlayer")
#onready var WeaponNode = get_node("RotationNode/WeaponSwing")
#onready var RotationNode = get_node("RotationNode")
var movedir = Vector2(0,0)
var CollisionNode
var playerPos
var mousePos
#export (PackedScene) var BulletType
var trauma = 0
onready var bullet = preload("res://Scenes/Bullet.tscn")
var haveBullet = true
var canShoot = true
var anim
var animNew

#onready var healthBar = $CanvasLayer/PlayerUI/HealthBar
#onready var healthUpProgress = $CanvasLayer/PlayerUI/HealthUpProgress

func _ready():
	set_physics_process(true)
	MOTION_SPEED = WITH_BULLET_SPEED
	$Control/ProgressBar.value = 100
	#RayNode = get_node("RayCast2D")	#For directions
#	CollisionNode = get_node("Collision")
#	lastTransferPoint = position
#	$RotationNode.hide()
#	updateHealthBar()
	#healthUpProgress.setMaxValue(3)

func _physics_process(delta):
	mousePos = get_global_mouse_position()
	#if playerControlEnabled:
	controls_loop(delta)
	movement_loop(delta)
	if haveBullet and $Control/ProgressBar.value <= 100:
		$Control/ProgressBar.value += 100/30
	if $Control/ProgressBar.value == 100:
		$Control/ProgressBar.hide()
		canShoot = true
#	speed_decay()
	#CollisionNode.disabled = false # Reenable collision (Has to do with swap code)
	updateCamera()

func updateCamera():
	var targetPosition = (mousePos*0.3+global_position*0.7)
	$Camera2D.global_position = (targetPosition*0.8+$Camera2D.global_position*0.2)
	var multiplier = randi()%2
	if multiplier == 0:
		multiplier = -1
	var offsetValue = (trauma*trauma) * 0.001 * multiplier
	$Camera2D.offset = Vector2(offsetValue, offsetValue)
	$Camera2D.rotation = trauma * 0.0001 * multiplier
	if trauma != 0:
		trauma -= 2.5
		if trauma < 0:
			trauma = 0

func instantCameraUpdate():
	$Camera2D.position = (get_global_mouse_position()*0.3+global_position*0.7)

func controls_loop(delta):
	var LEFT	= Input.is_action_pressed("ui_left")
	var RIGHT	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	var SHOOT	= Input.is_action_pressed("ui_shoot")

	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
#	if movedir.y > 0:
#		anim = "PlayerWalkingDown"
#	elif movedir.y < 0:
#		anim = "PlayerWalkingUp"
	if movedir.x > 0:
		#anim = "PlayerWalkingRight"
		$Sprite.flip_h = false
	elif movedir.x < 0:
		#anim = "PlayerWalkingRight"
		$Sprite.flip_h = true
	
	if SHOOT && canShoot:
		if haveBullet:
			var b = bullet.instance()
			var p = get_parent()
			p.add_child(b)
			b.position = position
			var mousePos = get_global_mouse_position()
			b.rotation = get_angle_to(mousePos)
			trauma = 80
			haveBullet = false
			canShoot = false
			$PlayerAudio.stream = load("res://Audio/1Gunshot.wav")
			#$PlayerAudio.volume_db = Global.masterSound
			$PlayerAudio.play()
			MOTION_SPEED = NORMAL_SPEED
			$Control/ProgressBar.value = 0
			var recoilDir = Vector2(1,0).rotated(get_angle_to(mousePos))
			var motion = -recoilDir.normalized() * MOTION_SPEED*3
			move_and_collide(motion*delta)
		
		else:
			$PlayerAudio.stream = load("res://Audio/1GunshotNobullet.wav")
			#$PlayerAudio.volume_db = Global.masterSound
			$PlayerAudio.play()


func movement_loop(delta):
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	if collision:
		if collision.collider.is_in_group("Bullet"):
			collision.collider.queue_free()
			haveBullet = true
			MOTION_SPEED = WITH_BULLET_SPEED
			$Control/ProgressBar.show()
			#bulletShootDelay(1)
		move_and_slide(motion)
	if movedir == Vector2():
		anim = "Idle"
	if anim != animNew:
		animNew = anim
		AnimNode.play(anim)

#func bulletShootDelay(sec):
#	$bulletDelayTimer.set_wait_time(sec) # Set Timer's delay to "sec" seconds
#	$bulletDelayTimer.start() # Start the Timer counting down
#	yield($bulletDelayTimer, "timeout") # Wait for the timer to wind down
#	canShoot = true