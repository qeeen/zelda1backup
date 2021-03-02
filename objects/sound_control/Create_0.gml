volume = 10;

playing = noone;
intro_length = 0;
full_length = 0;
has_intro = true;

function play_sound(sound){
	switch(sound){
		case "sword":
			audio_play_sound(snd_sword, 500, 0);
			audio_play_sound(snd_sword_comp, 300, 0);
			break;
		case "bomb":
			audio_play_sound(snd_bomb, 500, 0);
			break;
		case "hit":
			audio_play_sound(snd_hit, 500, 0);
			break;
		case "death":
			audio_play_sound(snd_death, 200, 0);
			break;
		case "pickup":
			audio_play_sound(snd_pickup, 400, 0);
			break;
	}
}

function switch_song(song){
	if(playing != noone){
		audio_stop_sound(playing);
	}
	switch(song){
		case "overworld":
			playing = audio_play_sound(sng_overworld, 1000, 0);
			intro_length = 7.780;
			full_length = 65.797;
			has_intro = true;
			break;
		case "dungeon":
			playing = audio_play_sound(sng_dungeon, 1000, 1);
			has_intro = false;
			break;
		case "boss":
			playing = audio_play_sound(sng_boss, 1000, 1);
			has_intro = false;
			break;
		case "none":
			playing = noone;
			has_intro = false;
			break;
	}
}


switch_song("overworld");