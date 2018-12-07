extends KinematicBody2D

const GRAVITY = 10
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var is_dead = false

export(int) var speed = 200
export(int) var hp = 1
export(Vector2) var size = Vector2(1, 1)

func _ready():
	scale = size
	pass

func dead():
	hp = hp - 1
	if hp <= 0:
		print("DEAD")
		is_dead = true
		velocity = Vector2(0, 0)
		#$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		var Death = get_node("Death")
		Death.play()
		hide()
		get_parent().hide()
		$Timer.start()

func RandNum():
	var killed = randi()%5+1
	return killed

func _physics_process(delta):
	if is_dead == false:
		
		velocity.x = speed * direction
		
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			#print("flip")
			$AnimatedSprite.flip_h = true
			
		$AnimatedSprite.play("run")
		
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "Player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.dead()

func _on_Timer_timeout():
	print("timeout")
	get_parent().show()
	queue_free()
