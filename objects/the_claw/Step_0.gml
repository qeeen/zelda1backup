if(!instance_exists(parent_ob)){
	instance_destroy();
}

dir = parent_ob.slef.dir;

if(!mapdata.paused){
	if(murder_mode){
		x += cos(degtorad(point_direction(x, y, target_x, target_y)))*spd;
		y += -sin(degtorad(point_direction(x, y, target_x, target_y)))*spd;
		if(link.y >= y)
			image_yscale = -1;
		murder_timer--;
	}
	else{
		x = parent_ob.x - 28;
		y = parent_ob.y - 10;
		image_yscale = 1;
	}
	
	if(murder_timer <= 0 || (x <= target_x + 4 && x >= target_x - 4 && y <= target_y + 4 && y >= target_y - 4)){
		murder_mode = false;
		murder_timer = 0;
	}
	
	if(place_meeting(x, y, link)){
		murder_mode = false;
		murder_timer = 0;
		
		var knock_xspd = -1;
		var knock_yspd = 0;
		var knock_spd = 5;
	
	/*
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
		}*/
		link.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, 2], 0, 1);
		//link.slef.request("hurt", [2], 1, 2);
	}
}