function skelly(_ob, _x, _y) : enem(_ob, _x, _y) constructor{
	patrol_timer = 0;
	last_req = ["idle", -1];
	norm_spd = 0.5;
	lunge_spd = 4;
	mv_spd = norm_spd;
	atk_dur = 15;
	max_health = 4;
	c_health = max_health;
	lunge_mode = false;
	lunge_dir = 0;
	
	//sprites
	sprite_r = spr_skelly_r;
	sprite_l = spr_skelly_l;
	sprite_f = spr_skelly_r;
	sprite_b = spr_skelly_l;
	ob.image_speed = 0.5;
	
	function input(){
		var p_dir = 0;
		
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
		
		if(patrol_timer <= 0){
			p_dir = irandom_range(1, 4);
			mv_spd = 0.5;
			
			if(instance_exists(link)){
				if(point_distance(ob.x, ob.y, link.x, link.y) <= vision_range && !approaching){
					p_dir = calc_direction(link.x, link.y);
				}
				
				if(lunge_mode){
					mv_spd = lunge_spd;
					p_dir = lunge_dir;
					lunge_mode = false;
				}
				
				if(mv_spd != lunge_spd){
					with(ob){
						var lunge_vision = 48;
						var yes = false;
						
						if(place_meeting(x+lunge_vision, y, link)){
							slef.lunge_dir = 1;
							yes = true;
						}
						if(place_meeting(x, y+lunge_vision, link)){
							slef.lunge_dir = 2;
							yes = true;
						}
						if(place_meeting(x-lunge_vision, y, link)){
							slef.lunge_dir = 3;
							yes = true;
						}
						if(place_meeting(x, y-lunge_vision, link)){
							slef.lunge_dir = 4;
							yes = true;
						}
						if(yes){
							slef.lunge_mode = true;
							p_dir = 0;
						}
					}
				}
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
		
			patrol_timer = 16/norm_spd;//irandom_range(35, 75);
			if(mv_spd = lunge_spd){
				patrol_timer = 16;
			}
		}
		else{
			request(last_req[0], last_req[1], 1, 0);
		}
		
		if(ent_state != "stunned"){
			patrol_timer--;
		}
	}
	
	function calc_sprite(){
		if(mv_spd == lunge_spd){
			sprite_r = spr_skelly_stab_r;
			sprite_l = spr_skelly_stab_l;
			sprite_f = spr_skelly_stab_f;
			sprite_b = spr_skelly_stab_b;
		}
		else{
			sprite_r = spr_skelly_r;
			sprite_l = spr_skelly_l;
			sprite_f = spr_skelly_r;
			sprite_b = spr_skelly_l;
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
		
		if(lunge_mode){
			img = spr_skelly_prep;
		}

		if(ent_state == "moving" || ent_state == "forced"){
			frm = (current_time/(100/ob.image_speed))%sprite_get_number(img)
		}
	}
	
	function do_hit(args){
		if(!invuln){
			request("hurt", [args[3]], 1, 2);
			request("knocked", args, 0, 1);
		}
	}
	
	function unique_step(){
		hit_on_touch();
	}
}