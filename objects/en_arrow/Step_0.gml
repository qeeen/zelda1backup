if(!mapdata.paused){
	if(place_meeting(x, y, link)){
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
		link.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, 2], 0, 1);
		//link.slef.request("hurt", [2], 1, 2);
	}

	x += cos(degtorad(mv_dir))*spd;
	y += -sin(degtorad(mv_dir))*spd;
}