extends Label

export var name_countdown = 'timer1'
export var wait_time = '00:00:00'
export var end_label = 'GET IT!'
export var unix_server = ''
export(bool) var auto_start = true
export(bool) var auto_restart = false
var ended:bool = false
var seconds:int = 0
var startDate = OS.get_datetime(true)
var startSeconds = 0
var loaded = false

var timer = Timer.new()
var http = HTTPRequest.new()

signal start(_name_countdown)
signal finish(_name_countdown)

# ----

export var save_path = "user://savegame.save"
var save_data = {}

func save_game()->void:
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)
	save_game.store_var(save_data)
	save_game.close()

func load_game()->void:
	var save_game = File.new()
	if not save_game.file_exists(save_path):
		return

	save_game.open(save_path, File.READ)
	save_data = save_game.get_var()
	save_game.close()

func getCountdown(timer_name = '')->Dictionary:
	var ret = null
	if save_data is Dictionary:
		if save_data.has("countdown"):
			if save_data['countdown'].has(timer_name):
				ret = save_data['countdown'][timer_name]
	return ret
	
func setCountdown(timer_name = '', data = {})->void:
	if !save_data is Dictionary:
		save_data = {}
	
	if !save_data.has("countdown"):
		save_data['countdown'] = {}
		
	if !save_data['countdown'].has(timer_name):
		save_data['countdown'][timer_name] = {}
			
	save_data['countdown'][timer_name] = data

func formatSeconds(_seconds:int = 0)->Array:
	var second = floor(_seconds % 60)
	var minute = floor((_seconds / 60) % 60)
	var hour = floor(_seconds / 3600)
	return [
		str(hour) if hour >= 10 else str('0', hour), 
		str(minute) if minute >= 10 else str('0', minute), 
		str(second) if second >= 10 else str('0', second),
		]

func formatTime2Seconds(_time = "")->int:
	var s = _time.split(":")
	return (int(s[0]) * 3600) + (int(s[1]) * 60) + (int(s[2]))



#-----------------------


func _ready():
	load_game()
	
	timer.connect("timeout", self, "_on_timer_timeout")
	http.connect("request_completed", self, "_on_http_request_completed")
	
	add_child(http)
	add_child(timer)
	
	if auto_start == true:
		_start()

func is_ended()->bool:
	return ended

func _on_timer_timeout():
	if !loaded: return
	
	if seconds >= 0:
		seconds -= 1
		_format()
	else:
		_finish()

func _format():
	if !loaded: return
	
	if seconds >= 0:
		var f = formatSeconds(seconds)
		self.text = str(f[0], ":", f[1], ":", f[2])

func _start(_wait_time = null, _restart = false):
	loaded = false
	if _wait_time != null:
		wait_time = _wait_time

	if _restart == true:
		setCountdown(name_countdown, null)
		save_game()
		
	_getDateTime()
	
func _initCountdown():
	if !loaded: return
	var current_timer = getCountdown(name_countdown)
	if current_timer is Dictionary:
		if current_timer.has("end"):
			seconds = int(current_timer.end) - int(startSeconds)
			if seconds < 0:
				_finish()
				return
	else:
		_newTimer()
	
	ended = false
	_format()
	timer.start()
	emit_signal("start", name_countdown)

func _newTimer()->void:
	var addSeconds = formatTime2Seconds(wait_time)
	var endSeconds = int(startSeconds) + int(addSeconds)
	
	seconds = int(endSeconds) - int(startSeconds)
	
	setCountdown(name_countdown, {
		"start": int(startSeconds),
		"end": int(endSeconds)
	})
	save_game()

func _finish():
	if !loaded: return
	ended = true
	emit_signal("finish", name_countdown)
	timer.stop()
	
	if end_label != "" and end_label!=null:
		self.text = str(end_label)
	
	if auto_restart == true:
		_start(wait_time, true)


func _getDateTime():
	if unix_server != '' and unix_server != null:
		var headers = ["Content-Type: text/plain"]
		http.request(unix_server, headers, true, HTTPClient.METHOD_GET)
	else:
		startDate = OS.get_datetime(true)
		startSeconds = OS.get_unix_time_from_datetime(startDate)
		loaded = true
		_initCountdown()

func _on_http_request_completed(result, response_code, headers, body):
	var ret = null
	if unix_server != '' and unix_server != null:
		match result:
			HTTPRequest.RESULT_SUCCESS:
				ret = body.get_string_from_utf8()
				if ret != null and ret != '':
					startSeconds = int(ret)
					loaded = true
	
	_initCountdown()


