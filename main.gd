extends Node2D


func _ready() -> void:
	$Gabriel.move_to(Vector2(300,175))
	
var time_hour = 8
var time_minute = 0


func _on_timer_timeout() -> void:
	time_minute += 1
	if time_minute == 60:
		time_minute = 0
		time_hour += 1
	var min_str = str(time_minute)
	if len(min_str) == 1:
		min_str = "0" + min_str
	$CanvasLayer/Label.text = str(time_hour) + ":" + min_str
