extends Node2D

func _ready():
    Console.add_command("sfx", play_sfx)
    Console.add_command("music", play_music)

func play_music():
    $MusicAudioPlayer.play()

func play_sfx():
    $SFXAudioPlayer.play()