extends Area2D

const SPEED = 600
var velocity = Vector2()
var direction = 1

func _ready():
	pass

func set_blade_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.flip_v = true
		#print("flip")
	else:
		$AnimatedSprite.flip_v = false


func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("knife")


func _on_VisibilityNotifier2D_screen_exited():
	#print("exit")
	queue_free()


func _on_Blade_Hit_entered(body):
	if "Enemy" in body.name:
		body.dead()
		queue_free()