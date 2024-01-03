extends RigidBody3D

## Quantidade de força aplicada para mover o foquete para cima
@export_range(750.0, 2500.0) var thrust = 1000.0
@export  var torque_thrust = 100.0
var is_transitioning = false

@onready var explosion_audio = $ExplosionAudio
@onready var success_audio = $SuccessAudio

func _ready():  
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(.0,.0,torque_thrust * delta))
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(.0,.0,-torque_thrust * delta))

func _on_body_entered(body):
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
			
		if "Fail" in body.get_groups():
			crash_sequence()
		
func crash_sequence():
	explosion_audio.play()
	set_process(false) #para a funcao _process(delta)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
	
func complete_level(next_level_file: String):
	success_audio.play()
	set_process(false) #para a funcao _process(delta)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))

