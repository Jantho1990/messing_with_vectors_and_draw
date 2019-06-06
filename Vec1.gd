extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 2000

var motion = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		motion.x = -SPEED * delta
	elif Input.is_action_pressed("ui_right"):
		motion.x = SPEED * delta
	else:
		motion.x = 0
	
	if Input.is_action_pressed("ui_up"):
		motion.y = -SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		motion.y = SPEED * delta
	else:
		motion.y = 0
	
	motion = move_and_slide(motion)
	
	update()

func _draw():
	draw_circle(position, 5, Color(1, 0, 0))