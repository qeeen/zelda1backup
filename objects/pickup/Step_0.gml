if(!mapdata.paused){
	switch(type){
		case "heart":
			sprite_index = spr_heart;
			break;
		case "pearl":
			sprite_index = spr_pearl;
			break;
		case "bomb":
			sprite_index = spr_bomb;
			break;
		case "fairy":
			sprite_index = spr_fairy;
			break;
		case "tome":
			sprite_index = spr_tome;
			break;
	}

	if(type == "fairy"){
		speed = 0.5;
		if(fairy_timer == 0){
			direction = choose(0, 90, 180, 270);
			fairy_timer = 32;
		}
		fairy_timer--;
	}

	if(life <= 0){
		instance_destroy();
	}
	life--;
}