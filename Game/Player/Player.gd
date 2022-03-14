extends KinematicBody

var direction = Vector3()
var speed = 10
var acceleration = 5
var velocity = Vector3()
var mouse_sensitivity = 0.1
var gravity = 9.8
var jump = 5
var falling = Vector3()
var jump_num = 0

onready var pivot = $pivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass 


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg2rad(-80), deg2rad(80))

func _process(delta):
	
	direction = Vector3()
	if not is_on_floor():
		falling.y -= gravity * delta
		
	move_and_slide(falling, Vector3.UP)
	
	if Input.is_action_pressed("move_foreward"):
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	if is_on_floor():
		jump_num = 0
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if jump_num == 0:
			falling.y = jump
			jump_num += 1
	
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if jump_num == 1:
			falling.y = jump
			jump_num += 2
	
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
