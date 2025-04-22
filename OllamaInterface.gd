extends Node

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	
var response


func callLLM(prompt):
	response = ""
	var url = "http://127.0.0.1:11434/api/generate"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"model": "llama3.2", "prompt": prompt, "stream":false})
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Request failed: ", error)
		return false
		
	var result = await http_request.request_completed
	return _process_response(result[1], result[3])

func _process_response(response_code, body) -> String:
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var response_json = JSON.parse_string(response_text)
		return response_json.get("response", "Error: No response field found")
	else:
		return "Error: " + str(response_code)
		

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var response_json = JSON.parse_string(response_text)
		response = response_json["response"]
	else:
		print("Error: ", response_code)
		
		
