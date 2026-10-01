extends CanvasLayer

@onready var label: Button = $Label

var status_dictionary = {
	
	GamaManager.GameStatus.DISCONNECTED : "Connect",
	GamaManager.GameStatus.WAITING : "Waiting for Players",
	GamaManager.GameStatus.READY : "Ready to Play",
	GamaManager.GameStatus.PLAYING : "Now Playing",
	GamaManager.GameStatus.OVER : "Game Over",
}

var game : GamaManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = get_parent() as GamaManager
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = status_dictionary[game.game_status]	
	


func _on_label_pressed() -> void:
	match game.game_status:
		game.GameStatus.DISCONNECTED:
			MM.connect_to_host()
	
	
	
	
	
