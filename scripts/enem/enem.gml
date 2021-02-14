function enem(_ob, _x, _y) : living(_ob, _x, _y) constructor{
	patrol_timer = 0;
	last_req = ["idle", -1];
	mv_spd = 0.5;
	vision_range = 64;
	max_health = 2;
	c_health = max_health;
	on_hit_dmg = 1;
	
	init_pos = 0;
	
	//sprites
	sprite_r = spr_crab_r;
	sprite_l = spr_crab_l;
	sprite_f = spr_crab_r;
	sprite_b = spr_crab_l;
	
	function input(){
		var p_dir = 0;
		if(patrol_timer <= 0){
			p_dir = irandom_range(0, 4);
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
		
			patrol_timer = 16/mv_spd;//irandom_range(15, 45);
		}
		else{
			request(last_req[0], last_req[1], 1, 0);
		}
		
		if(ent_state != "stunned"){
			patrol_timer--;
		}
	}
	
	function do_die(args){
		ds_list_add(mapdata.killed_enemies, init_pos);
		if(choose(0, 1)){
			with(instance_create_layer(ob.x, ob.y, "Instances", pickup)){
				type = choose("heart", "pearl", "bomb", "fairy");
			}
		}
		instance_create_layer(ob.x, ob.y, "Instances", death_anim);
		instance_destroy(ob);
	}
	
	function unique_step(){
		hit_on_touch();
	}
	
	function calc_direction(p_x, p_y){
			var base_ang = abs(point_direction(ob.x, ob.y, p_x, p_y));
			var ang_off = base_ang%90;
			if(ang_off >= 45){
				base_ang += 90-ang_off;
			}
			else{
				base_ang -= ang_off;
			}
			//show_message(base_ang);
			switch(base_ang){
				case 0:
					return 1;
					break;
				case 360:
					return 1;
					break;
				case 270:
					return 2;
					break;
				case 180:
					return 3;
					break;
				case 90:
					return 4;
					break;
			}
	}
	
	
	
	function hit_on_touch(){
		with(ob){
			if(place_meeting(x, y, link)){
				var knock_xspd = 0;
				var knock_yspd = 0;
				var knock_spd = 5;
	
				switch(link.slef.dir){
					case 2:
						knock_xspd = 1;
						knock_yspd = 0;
						break;
					case 1:
						knock_xspd = 0;
						knock_yspd = -1;
						break;
					case 0:
						knock_xspd = -1;
						knock_yspd = 0;
						break;
					case 3:
						knock_xspd = 0;
						knock_yspd = 1;
						break;
				}
				link.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, slef.on_hit_dmg], 0, 1);
			}
		}
	}
}

