#Johann Massyn, 23/06/2019
#Godot (3.1) 3D Player movement script

#Atatch script to 3d node with following structure
#Kinematic body: Player
#  - CollisionShape: CollisionShape
#  - Camera: Camera

extends KinematicBody

export (bool) var can_move = true #Alow player to input movment.
export (bool) var can_sprint = true #Alow player to toggle sprint movment.
export (float) var move_speed = 8 #Players movement speed
export (float) var move_speed_sprint = 16 #Players sprint movement speed
export (bool) var move_sprint = false #Player sprinting toggle
export (float) var move_acceleration = 7 #Players acceleration to movment speed 
export (float) var move_deacceleration = 10 #Players deacceleration from movment speed
export (bool) var mouse_captured = true #Toggles mouse captured mode
export (float) var mouse_sensitivity_x = 0.3 #Mouse sensitivity X axis
export (float) var mouse_sensitivity_y = 0.3 #Mouse sensitivity Y axis
export (float) var mouse_max_up = 90 #Mouse max look angle up
export (float) var mouse_max_down = -80 #Mouse max look angle down
export (float) var Jump_speed = 6 #Players jumps speed
export (bool) var allow_fall_input = true #Alow player to input movment when falling
export (bool) var stop_on_slope = false #Toggle sliding on slopes
export (float) var max_slides = 4 #Maximum of slides
export (float) var floor_max_angle = 60 #Maximum slop angle player can traverse
export (bool) var infinite_inertia = false #Toggle infinite inertia
export (float) var gravaty = 9.81 #Gravaty acceleration
export (Vector3) var gravaty_vector = Vector3(0, -1, 0) #Gravaty normal direction vector
export (Vector3) var floor_normal = Vector3(0, 1, 0) #Floor normal direction vector
export (Vector3) var jump_vector = Vector3(0, 1, 0) #Jump normal direction vector
export (Vector3) var velocity = Vector3(0, 0, 0) #Initial velocity

func _ready():
	if mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _process(delta):
	pass
	
func _physics_process(delta):
	
	#player movement XY
	var dir = Vector3(0, 0, 0)
	if can_move and (is_on_floor() or allow_fall_input):
		
		#Left
		if Input.is_action_pressed("move_left"):
			dir.x -= 1
			
		#Right
		if Input.is_action_pressed("move_right"):
			dir.x += 1
			
		#Forward
		if Input.is_action_pressed("move_forward"):
			dir.z -= 1;
		
		#Backwards	
		if Input.is_action_pressed("move_backwards"):
			dir.z += 1
			
		#Jump
		if Input.is_action_pressed("move_jump") and is_on_floor():
			velocity += jump_vector * Jump_speed - (jump_vector * -1).normalized() * velocity.dot(jump_vector * -1)
	
		#Sprint toggle
		if can_sprint and Input.is_action_just_pressed("move_sprint") and is_on_floor():
			move_sprint = true
			
		if can_sprint and not Input.is_action_pressed("move_sprint") and is_on_floor():
			move_sprint = false
	
	#Smooth movement
	dir = transform.basis.xform(dir.normalized()) * (move_speed_sprint if move_sprint else move_speed)
	if is_on_floor() or dir != Vector3(0, 0, 0):
		var acceleration = move_acceleration if dir.dot(velocity) else move_deacceleration
		var vp = gravaty_vector.normalized() * velocity.dot(gravaty_vector)
		velocity = (velocity - vp).linear_interpolate(dir, acceleration * delta) + vp
	
	#Gravaty
	if !is_on_floor():
		velocity += gravaty_vector * gravaty * delta
	
	#Player move
	move_and_slide(velocity, floor_normal, stop_on_slope, max_slides, deg2rad(floor_max_angle), infinite_inertia)
	pass


func _input(event):
	#Mouse movement
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotation_degrees.y += -event.relative.x * mouse_sensitivity_x
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x + -event.relative.y * mouse_sensitivity_y, mouse_max_down, mouse_max_up)
	pass