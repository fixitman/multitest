extends Node
const PORT := 8910
const HOST := "127.0.0.1"  




func start_host():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		

func connect_to_host():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(HOST,PORT,0,0,0,0)
	if err == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.connected_to_server.connect(_on_connected_to_server)
		
	
func _on_connected_to_server():
	print("%d connected to server" % multiplayer.get_unique_id())
