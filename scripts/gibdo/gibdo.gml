function gibdo(_ob, _x, _y) : enem(_ob, _x, _y) constructor{
	patrol_timer = 0;
	last_req = ["idle", -1];
	mv_spd = 0.3;
	atk_dur = 15;
	max_health = 10;
	c_health = max_health;
	
	//sprites
	sprite_r = spr_gibdo;
	sprite_l = spr_gibdo;
	sprite_f = spr_gibdo;
	sprite_b = spr_gibdo;
	ob.image_speed = 0.3;
	
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
			if(instance_exists(link)){
				if(point_distance(ob.x, ob.y, link.x, link.y) <= vision_range && !approaching){
					p_dir = calc_direction(link.x, link.y);
				}
			}
			
			switch(p_dir){
				/*case 0:
					last_req = ["idle", -1];
					request(last_req[0], last_req[1], 1, 0);
					break;*/
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