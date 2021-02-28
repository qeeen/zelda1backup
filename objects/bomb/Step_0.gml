if(!mapdata.paused){
	if(fuse <= 0){
		with(instance_create_layer(x, y, "Instances", explosion)){
			dir = other.dir;
		}
		sound_control.play_sound("bomb");
		instance_destroy();
	}
	fuse--;
}