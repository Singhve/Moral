extends KinematicBody2D


export(int) var SPEED = 400
const GRAVITY = 10
export(int) var JUMP_POWER = -700
const FLOOR = Vector2(0, -1)
const BLADE = preload("res://Assets/Blade.tscn")

var velocity = Vector2()
var on_ground = false
var is_attacking = false
var is_dead = false


func _physics_process(delta):
	
	if is_dead == false:
	
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = SPEED
				if is_attacking == false:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = -SPEED
				if is_attacking == false:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground == true && is_attacking == false:
				$AnimatedSprite.play("idle")
			
		if Input.is_action_pressed("ui_up"):
			if is_attacking == false:
				if on_ground == true:
					velocity.y = JUMP_POWER
					$AnimatedSprite.play("jump")
					on_ground = false
	
		if Input.is_action_just_pressed("ui_accept") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("throw")
			var Blade_Shoot = get_node("Blade_Shoot")
			Blade_Shoot.play()
			var blade = BLADE.instance()
			if sign($Position2D.position.x) == 1:
				blade.set_blade_direction(1)
			else:
				blade.set_blade_direction(-1)
			get_parent().add_child(blade)
			blade.position = $Position2D.global_position
			is_attacking = false
	
		velocity.y += GRAVITY
	
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else:
					$AnimatedSprite.play("idle")
	
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					#print("hit Enemy")
					dead()
				if get_slide_collision(i).collider.is_in_group("Fall"):
					#print("fell to Death")
					dead()

func dead():
	#print("DEAD")
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	var Death = get_node("Death")
	Death.play()
	$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene("Assets/DeadMenu.tscn")
