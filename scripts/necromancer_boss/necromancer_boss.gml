function necromancer_boss(_ob, _x, _y) : enem(_ob, _x, _y) constructor{
	patrol_timer = 0;
	last_req = ["idle", -1];
	mv_spd = 0.3;
	atk_dur = 15;
	max_health = 30;
	c_health = max_health;
	atk_timer = 32/mv_spd;
	casting = false;
	resurrecting = false;
	shot_times = [0, 0];
	attack_counter = 0;
	current_undead = "skelly";
	
	//sprites
	sprite_r = spr_necro_r;
	sprite_l = spr_necro_l;
	sprite_f = spr_necro_r;
	sprite_b = spr_necro_l;
	ob.mask_index = spr_necro_r;
	
	sound_control.switch_song("boss");
	
	function input(){
		var p_dir = 0;
		
		if(c_health >= 22){
			current_undead = "skelly";
		}
		else if(c_health >= 16){
			current_undead = "gibdo";
		}
		else if(c_health >= 8){
			current_undead = "jiangshi";
		}
		else{
			current_undead = "darknut";
		}
		
		var approaching = false;
		with(ob){
			switch(slef.dir){
				case 0:
					if(place_meeting(x+1, y, wall)){
						approaching = true;
					}
					break;
				case 1:
					if(place_meeting(x, y+1, wall)){
						approaching = true;
					}
					break;
				case 2:
					if(place_meeting(x-1, y, wall)){
						approaching = true;
					}
					break;
				case 3:
					if(place_meeting(x, y-1, wall)){
						approaching = true;
					}
					break;
			}
		}
		if(approaching){
			patrol_timer = 0;
		}
		
		if(casting && (floor(patrol_timer) == shot_times[0] || floor(patrol_timer) == shot_times[1] || patrol_timer == 16/mv_spd-1)){
			shoot(point_direction(ob.x, ob.y, link.x, link.y));
			shoot(point_direction(ob.x, ob.y, link.x, link.y) + 27);
			shoot(point_direction(ob.x, ob.y, link.x, link.y) - 27);
		}
		
		if(patrol_timer <= 0){
			p_dir = irandom_range(1, 4);
			if(instance_exists(link)){
				if(point_distance(ob.x, ob.y, link.x, link.y) <= vision_range && !approaching){
					p_dir = calc_direction(link.x, link.y);
				}
			}
			
			if(instance_number(struct_enem) > 4){
				attack_counter = 2;
			}
			
			casting = false;
			resurrecting = false;
			if(atk_timer <= 0 && attack_counter == 2){
				p_dir = 0;
				casting = true;
				atk_timer = 48/mv_spd;
				attack_counter = 0;
				shot_times[0] = floor(2*(16/mv_spd)/3);
				shot_times[1] = floor((16/mv_spd)/3);
				
				var fx = instance_create_layer(ob.x, ob.y, "Instances", necro_poof);
				if(img == spr_necro_l){
					fx.image_xscale = -1;
				}
				new_pos_angle = (180+point_direction(256/2, 240/2, link.x, link.y))%360;
				ob.x = 256/2 + cos(degtorad(new_pos_angle))*64;
				ob.y = 240/2 - sin(degtorad(new_pos_angle))*64;
			}
			else if(atk_timer <= 0){
				p_dir = 0
				resurrecting = true;
				atk_timer = 48/mv_spd;
				if(c_health <= 16){
					atk_timer = 32/mv_spd;
				}
				switch(current_undead){
					case "skelly":
						with(instance_create_layer(256/2, 240/2, "Instances", struct_enem)){slef = new skelly(id, x, y); slef.init_pos = [mapdata.mapx, mapdata.mapy, 0, 0];}
						break;
					case "gibdo":
						with(instance_create_layer(256/2, 240/2, "Instances", struct_enem)){slef = new gibdo(id, x, y); slef.init_pos = [mapdata.mapx, mapdata.mapy, 0, 0];}
						break;
					case "jiangshi":
						with(instance_create_layer(256/2, 240/2, "Instances", struct_enem)){slef = new jiangshi(id, x, y); slef.init_pos = [mapdata.mapx, mapdata.mapy, 0, 0];}
						break;
					case "darknut":
						with(instance_create_layer(256/2, 240/2, "Instances", struct_enem)){slef = new darknut(id, x, y); slef.init_pos = [mapdata.mapx, mapdata.mapy, 0, 0];}
						break;
				}
				attack_counter++;
			}
			
			switch(p_dir){
				case 0:
					last_req = ["idle", -1];
					request(last_req[0], last_req[1], 1, 0);
					break;
				case 1:
					last_req = ["moving", [mv_spd, 0]];
					request(last_req[0], last_req[1], 1, 0);
					break;
				case 2:
					last_req = ["moving", [0, mv_spd]];
					request(last_req[0], last_req[1], 1, 0);
					break;
				case 3:
					last_req = ["moving", [-mv_spd, 0]];
					request(last_req[0], last_req[1], 1, 0);
					break;
				case 4:
					last_req = ["moving", [0, -mv_spd]];
					request(last_req[0], last_req[1], 1, 0);
					break;
			}
		
			patrol_timer = 16/mv_spd;//irandom_range(35, 75);
		}
		else{
			request(last_req[0], last_req[1], 1, 0);
		}
		
		if(ent_state != "stunned"){
			patrol_timer--;
			atk_timer--;
		}
	}
	
	function shoot(angle){
		with(instance_create_layer(ob.x, ob.y, "top_layer", necro_shot)){
			mv_dir = angle;
			spd = 1.5;
		}
	}
	
	function do_hit(args){
		if(!invuln){
			request("hurt", [args[3]], 1, 2);
			request("knocked", args, 0, 1);
		}
	}
	
	function do_die(args){
		sound_control.switch_song("none");
		instance_create_layer(ob.x, ob.y, "Instances", death_anim);
		with(struct_enem){
			slef.request("die", [0], 1, 0);
		}
		instance_destroy(ob);
	}
	
	function calc_sprite(){
		if(casting){
			sprite_r = spr_necro_cast_r;
			sprite_l = spr_necro_cast_l;
			sprite_f = spr_necro_cast_r;
			sprite_b = spr_necro_cast_l;
		}
		else if(resurrecting){
			sprite_r = spr_necro_res_r;
			sprite_l = spr_necro_res_l;
			sprite_f = spr_necro_res_r;
			sprite_b = spr_necro_res_l;
		}
		else{
			sprite_r = spr_necro_r;
			sprite_l = spr_necro_l;
			sprite_f = spr_necro_r;
			sprite_b = spr_necro_l;
		}
		switch(dir){
			case 0:
				img = sprite_r;
				break;
			case 1:
				img = sprite_f;
				break;
			case 2:
				img = sprite_l;
				break;
			case 3:
				img = sprite_b;
				break;
		}
		
			
		if(ent_state == "moving" || ent_state == "forced" || resurrecting){
			frm = (current_time/(100/ob.image_speed))%sprite_get_number(img)
		}
	}
	
	function unique_step(){
		hit_on_touch();
	}
}