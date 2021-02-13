if(!mapdata.paused){
	image_speed = norm_anim_spd;
	if(place_meeting(x, y, struct_enem)){
		var en = ds_list_create();
		instance_place_list(x, y, struct_enem, en, 1);
		for(var i = 0; i < ds_list_size(en); i++){
			var c_en = en[| i];
			for(var k = 0; k < ds_list_size(all_hit); k++){
				if(all_hit[k] == c_en){
					c_en = noone;
					break;
				}  
			}
			if(!instance_exists(c_en)){
				continue;
			}
			ds_list_add(en, all_hit);
		
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
			c_en.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, 8], 0, 1);
		}
		ds_list_destroy(en);
	}
}
else{
	image_speed = 0;
}