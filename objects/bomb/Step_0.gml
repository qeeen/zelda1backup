if(!mapdata.paused){
	if(fuse <= 0){
		with(instance_create_layer(x, y, "Instances", explosion)){
			dir = other.dir;
		}
		instance_destroy();
	}
	fuse--;
}