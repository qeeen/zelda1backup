if(!mapdata.paused){
	if(place_meeting(x, y, link)){
		var knock_xspd = 0;
		var knock_yspd = 0;
		var knock_spd = 5;

		link.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, 1], 0, 1);
	}

	x += cos(degtorad(mv_dir))*spd;
	y += -sin(degtorad(mv_dir))*spd;
}