if(!mapdata.paused){
	if(sprite_index == spr_blue_flame){
		life--;
		if(flame_life > 0){
			flame_life--;
		}
	
		if(life == 0){
			spd = 0;
			flame_life = 30;
		}
		if(flame_life <= 0 && life <= 0){
			instance_destroy();
		}
	}

	if(place_meeting(x, y, struct_enem)){
		var en = instance_place(x, y, struct_enem);
		var knock_xspd = 0;
		var knock_yspd = 0;
		var knock_spd = 5;
	
		switch(dir){
			case 2:
				knock_xspd = -1;
				knock_yspd = 0;
				break;
			case 1:
				knock_xspd = 0;
				knock_yspd = 1;
				break;
			case 0:
				knock_xspd = 1;
				knock_yspd = 0;
				break;
			case 3:
				knock_xspd = 0;
				knock_yspd = -1;
				break;
		}
		en.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, 3], 0, 1);
		if(sprite_index != spr_blue_flame){
			instance_destroy();
		}
		//link.slef.request("hurt", [2], 1, 2);
	}

	x += cos(degtorad(mv_dir))*spd;
	y += -sin(degtorad(mv_dir))*spd;
}