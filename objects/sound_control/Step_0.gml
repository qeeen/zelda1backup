if(audio_sound_get_track_position(playing) > full_length){
	audio_sound_set_track_position(playing, audio_sound_get_track_position(playing) - (full_length-intro_length));
	
}
show_debug_message(audio_sound_get_track_position(playing))
