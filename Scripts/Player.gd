extends KinematicBody2D

export var NORMAL_SPEED = 500
var MOTION_SPEED = NORMAL_SPEED
#onready var SpriteNode = get_node("Sprite")
#onready var AnimNode = get_node("AnimationPlayer")
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


#onready var healthBar = $CanvasLayer/PlayerUI/HealthBar
#onready var healthUpProgress = $CanvasLayer/PlayerUI/HealthUpProgress

func _ready():
	set_physics_process(true)
	#RayNode = get_node("RayCast2D")	#For directions
#	CollisionNode = get_node("Collision")
#	lastTransferPoint = position
#	$RotationNode.hide()
#	updateHealthBar()
	#healthUpProgress.setMaxValue(3)

func _physics_process(delta):
	mousePos = get_global_mouse_position()
	#if playerControlEnabled:
	controls_loop()
	movement_loop(delta)
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

func controls_loop():
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
#	if movedir.x > 0:
#		anim = "PlayerWalkingRight"
#		$Sprite.flip_h = false
#	elif movedir.x < 0:
#		anim = "PlayerWalkingRight"
#		$Sprite.flip_h = true
	var shootAvailable = true
	
	if SHOOT && haveBullet:
		var b = bullet.instance()
		var p = get_parent()
		p.add_child(b)
		b.position = position
		var mousePos = get_global_mouse_position()
		b.rotation = get_angle_to(mousePos)
		trauma = 40
		haveBullet = false

		
#		$PlayerAudio.stream = load("res://Audio/WarpSFX.wav")
#		$PlayerAudio.volume_db = Global.masterSound
#		$PlayerAudio.play()
#
#	if SWAP && swapAvailable && swapUnlocked:
#		playerPos = SpriteNode.position
#		var space_state = get_world_2d().direct_space_state
#		var result = space_state.intersect_ray(position, mousePos, [self], 5) # 5 refers to layer mask
#		if result:
#			if result.collider.is_in_group("Enemy"):
#				swappedRecently = true
#				swapPlaces(self, result.collider)
#				trauma = 110
#				$PlayerAudio.stream = load("res://Audio/ActualWarpSFX.wav")
#				$PlayerAudio.volume_db = Global.masterSound
#				$PlayerAudio.play()
#				swapAvailable = false
#				SpriteNode.set("modulate",Color(1,0.3,0.3,1))
#				swapInvuln = true
#				swapDelay(SWAP_DELAY)
#				swapInvuln(swapInvulnTime)
#				swapNotice(swapNoticeTime)
#
#	mousePos = get_global_mouse_position()
#	var attackDirection = Vector2(1, 0).rotated(get_angle_to(mousePos))
#	RotationNode.rotation_degrees = rad2deg(get_angle_to(mousePos))
#
#	if BARRIER and barrierAvailable && barrierUnlocked:
#		barrierAvailable = false
#		$RotationNode.show()
#		$Sprite.modulate.g = 0
#		WeaponNode.attack(attackDirection)

func movement_loop(delta):
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	if collision:
		if collision.collider.is_in_group("Bullet"):
			collision.collider.queue_free()
			haveBullet = true
		move_and_slide(motion)
#	if movedir == Vector2():
#		anim = "Idle"
#	if anim != animNew:
#		animNew = anim
#		AnimNode.play(anim)
#	for i in range(get_slide_count()):
#		var collisions = get_slide_collision(i)
#		if collisions:	# Note: Causes a double hit bug where if you touch a projectile in the same frame it touches you,
#		# you get hit twice. This can be solved through invulnerability frames after being hit.
#			if collisions.collider.is_in_group("Projectile"):
#				var projectile = collisions.collider #The extra .get_node("./") doesn't seem to do anything, not sure why?
#				projectile.collide(self)
#			if collisions.collider.is_in_group("Pickup"):
#				var collider = collisions.collider.get_node("./")
#				collider.applyEffect(self)
#		pass
