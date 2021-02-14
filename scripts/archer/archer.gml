function archer(_ob, _x, _y) : enem(_ob, _x, _y) constructor{
	patrol_timer = 0;
	last_req = ["idle", -1];
	mv_spd = 0.5;
	atk_dur = 15;
	max_health = 4;
	c_health = max_health;
	
	//sprites
	sprite_r = spr_archer_r;
	sprite_l = spr_archer_l;
	sprite_f = spr_archer_f;
	sprite_b = spr_archer_b;
	
	function input(){
		var p_dir = 0;
		if(patrol_timer == 0){
			p_dir = irandom_range(1, 4);
			
			if(instance_exists(link)){
				if(point_distance(ob.x, ob.y, link.x, link.y) <= vision_range && choose(false, true)){
					p_dir = calc_direction(link.x, link.y);
				}
				if((irandom_range(0, 2) == 0) && (calc_direction(link.x, link.y)-1) == dir){
						p_dir = 0
				}
			}
			
			switch(p_dir){
				case 0:
					last_req = ["idle", -1];
					request(last_req[0], last_req[1], 1, 0);
					request("attacking", -1, 1, 0);
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
			sprite_r = spr_archer_r;
			sprite_l = spr_archer_l;
			sprite_f = spr_archer_f;
			sprite_b = spr_archer_b;
		}
	}
	
	function unique_step(){
		hit_on_touch();
	}
	
	function do_attack(args){
		sprite_r = spr_archer_shoot_r;
		sprite_l = spr_archer_shoot_l;
		sprite_f = spr_archer_shoot_f;
		sprite_b = spr_archer_shoot_b;
		ent_state = "stunned"
		var atk_x = dir == 0 ? 1:-1;
		var atk_y = dir == 1 ? 1:-1;
		
		with(instance_create_layer(ob.x + t_size*atk_x*axis, ob.y + t_size*atk_y*(!axis), "Instances", en_arrow)){
				dir = other.dir;
				image_angle = !other.axis*90;
				
				if(other.dir == 1 || other.dir == 2){
					image_xscale = -1;
				}
				if(other.dir == 1){
					image_yscale = -1;
				}
				
				mv_dir = point_direction(x, y, other.ob.x, other.ob.y)+180;
				spd = 1.5;
				
				life = other.atk_dur;
				ob = other.ob;
		}
		stun_timer = atk_dur;
	}
}