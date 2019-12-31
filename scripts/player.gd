extends KinematicBody2D

const PRE_SPEAR = preload("res://prefabs/spear_hand.tscn")
const MAX_LIFE = 100
const SPEED = 200

var life = MAX_LIFE
var has_spear = false
var loaded = true

func _ready():
	$area_hit.connect("hitted", self, "on_area_hitted")
	$area_hit.connect("destroid", self, "on_area_destroid")
	pass

func _physics_process(delta):
	var x_dir = 0
	var y_dir = 0
	
	if Input.is_action_pressed("ui_right"):
		x_dir += 1
		$anim_sprite.play("walk")
	if Input.is_action_pressed("ui_left"):
		x_dir -= 1
		$anim_sprite.play("walk")
	if Input.is_action_pressed("ui_up"):
		y_dir -= 1
		$anim_sprite.play("walk")
	if Input.is_action_pressed("ui_down"):
		y_dir += 1
		$anim_sprite.play("walk")
	
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		$anim_sprite.play("idle")
	
	if Input.is_action_just_pressed("ui_attack"):# and has_spear and loaded:
		shoot_spear()
	
	if has_spear:
		$spear_hand.show()
	else:
		$spear_hand.hide()
	
	look_at(get_global_mouse_position())
	move_and_slide(Vector2(x_dir, y_dir) * SPEED)

func shoot_spear():
	get_tree().call_group("spear", "spear_false")
	var position_mouse = get_global_mouse_position()
	rotation += get_angle_to(position_mouse)
	
	var spear_attack = PRE_SPEAR.instance()
	spear_attack.global_position = $spear_hand.global_position / 2
	spear_attack.rotation = global_rotation
	spear_attack.dir = Vector2(cos(rotation), sin(rotation))
	spear_attack.target_position = get_global_mouse_position()
	spear_attack.type = "player_attack"
	get_parent().add_child(spear_attack)
	
	has_spear = false
	loaded = false
	$reload.start()

func take_spear():
	if has_spear:
		get_tree().call_group("spear", "spear_true")
	else:
		get_tree().call_group("spear", "spear_true")
		has_spear = true

func _on_reload_timeout():
	$reload.stop()
	loaded = true
	
func on_area_hitted(damage, health, node):
	pass

func on_area_destroid():
#	queue_free()
	pass
