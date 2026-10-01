class_name GamaManager extends Node2D

@onready var label: Button = $UI/Label

var p1 : int = 0
var p2 : int = 0

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
		await get_tree().create_timer(1).timeout
		print( "[%d]  p1: %d    p2:%d" % [multiplayer.get_unique_id(),p1,p2])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_peer_connected(id: int):
	if multiplayer.is_server():
		if p1 == 0:
			p1 = id
		elif p2 == 0:
			p2 = id
			game_status = GameStatus.READY
	print( "[%d]  p1: %d    p2:%d" % [multiplayer.get_unique_id(),p1,p2])
	pass

func _on_peer_disconnected(id: int):
	if is_multiplayer_authority():
		if p1 == id:
			p1 = 0
			game_status = GameStatus.WAITING
		elif p2 == id:
			p2 = 0
			game_status = GameStatus.WAITING
		
	
	
	
@rpc("authority","call_local","reliable")
func update_game_status(status: GameStatus):
	if game_status == status: return
	
	game_status = status
	
		
