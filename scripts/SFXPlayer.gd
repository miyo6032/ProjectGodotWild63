extends AudioStreamPlayer2D

func _ready():
    bus = "SFX"
    volume_db = 10

func play_sfx(audio: AudioStream, global_pos):
    position = global_pos
    stream = audio
    play()
