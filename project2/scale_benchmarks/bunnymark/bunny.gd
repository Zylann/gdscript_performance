extends Sprite


var vx = randi() % 200 + 50
var vy = randi() % 200 + 50
var ay = 980


func _ready():
	set_pos(Vector2(50, 50))
	set_process(true)


func _process(delta):
	var pos = get_pos()
	
	pos.x = pos.x + vx * delta
	pos.y = pos.y + vy * delta
	
	vy = vy + ay * delta
	
	if pos.x > 800:
		vx = -vx
		pos.x = 800
		
	if pos.x < 0:
		vx = abs(vx)
		pos.x = 0
		
	if pos.y > 600:
		vy = -0.85 * vy
		pos.y = 600
		if randf() > 0.5:
			vy = -(randi() % 1100 + 50)
		
	if pos.y < 0:
		vy = 0
		pos.y = 0
	
	set_pos(pos)


