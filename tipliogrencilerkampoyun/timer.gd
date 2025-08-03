extends Timer
var distance := 0  

func _ready():
	$DistanceTimer.timeout.connect(_on_DistanceTimer_timeout)

func _on_DistanceTimer_timeout():
	distance += 1
	$Metre.text = str(distance) + " Direniş"
