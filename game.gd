class_name GamaManager extends Node2D

@onready var label: Button = $UI/Label

var player_data = {
	1:0,
	2:0,
	"local_player":0
}


enum GameStatus  {DISCONNECTED,WAITING, READY, PLAYING, OVER}

var game_status  = GameStatus.DISCONNECTED:
	set(v):
		if game_status != v:
			game_status = v
			update_game_status.rpc(v)




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		MM.start_host()
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	else:
		#MM.connect_to_host()
		#multiplayer.peer_connected.connect(_on_peer_connected)
		#await get_tree().create_timer(1).timeout
		print( "[%d]  p1: %d    p2:%d" % [multiplayer.get_unique_id(),player_data[1],player_data[2]])


func _on_peer_connected(id: int):
	if multiplayer.is_server():
		if player_data[1] == 0:
			player_data[1] = id
		elif player_data[2] == 0:
			player_data[2] = id
			game_status = GameStatus.READY
		update_dictionary.rpc(player_data)
	pass

func _on_peer_disconnected(id: int):
	if multiplayer.is_server():
		if player_data[1] == id:
			player_data[1] = 0
			game_status = GameStatus.WAITING
		elif player_data[2] == id:
			player_data[2] = 0
			game_status = GameStatus.WAITING
		update_dictionary.rpc(player_data)
		
	
	
	
@rpc("any_peer","call_remote","reliable")
func update_game_status(status: GameStatus):
	print ("update called by %d" % multiplayer.get_remote_sender_id())
	if game_status == status: return
	
	game_status = status


@rpc("authority","call_remote","reliable")
func update_dictionary(dict: Dictionary):
	player_data = dict
	player_data["local_player"] = get_pn_by_id(multiplayer.get_unique_id())
	print("[%d]: " % multiplayer.get_unique_id(), player_data)
	pass
		
		


func get_id_by_pn(pn: int) -> int:
	if player_data.has(pn):
		return player_data[pn]
	return 0
	
func get_pn_by_id(id:int) -> int:
	for pn in player_data.keys():
		if player_data[pn] == id:
			return pn
	return 0
	
	

	
	
	
