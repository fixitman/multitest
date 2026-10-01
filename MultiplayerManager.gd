extends Node
const PORT := 8910
const HOST := "127.0.0.1"  



func start_host():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		peer.peer_connected.connect(_on_peer_connected)
		peer.peer_disconnected.connect(_on_peer_disconnected)

func connect_to_host():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(HOST,PORT,0,0,0,0)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		peer.peer_connected.connect(_on_peer_connected)
		peer.peer_disconnected.connect(_on_peer_disconnected)
		get_node("../Game/UI/Label").text = str(multiplayer.get_unique_id())
		
	


func _on_peer_connected(id : int):
	print( "peer %d connected" % id)
	
func _on_peer_disconnected(id : int):
	print( "peer %d disconnected" % id)
