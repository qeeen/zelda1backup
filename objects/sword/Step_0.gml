if(!mapdata.paused){
	life--;

	if(life <= 0)
		instance_destroy();

	if(life <= 4){
		spd = t_sizeq;
		mv_dir = point_direction(x, y, ob.x, ob.y);
	}
	

	if(place_meeting(x, y, struct_enem)){
		var inst = instance_place(x, y, struct_enem);
		var knock_xspd = 0;
		var knock_yspd = 0;
		var knock_spd = 5;
	
		switch(ob.slef.dir){
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
		inst.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, dmg], 1, 2);
		//inst.slef.request("knocked", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10], 0, 1);
		//inst.slef.request("hurt", [2], 1, 2);
	}
	x += cos(degtorad(mv_dir))*spd;
	y += -sin(degtorad(mv_dir))*spd;
}

if(mapdata.pause_timer > 0){
	visible = false;
}
else{
	visible = true;
}

if(place_meeting(x, y, tall_grass) && !hit_grass){
	var tg = instance_place(x, y, tall_grass);
	instance_destroy(tg);
	hit_grass = true;
}



















