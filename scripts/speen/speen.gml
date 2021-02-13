function speen(_ob, _x, _y) : enem(_ob, _x, _y) constructor{
	patrol_timer = 0;
	last_req = ["idle", -1];
	mv_spd = 1.5;
	atk_dur = 15;
	max_health = 1;
	c_health = max_health;
	target_x = 0;
	target_y = 0;
	target_timer = 0;
	no_clip = true;
	
	//sprites
	sprite_r = spr_speen_r;
	sprite_l = spr_speen_l;
	sprite_f = spr_speen_r;
	sprite_b = spr_speen_l;
	
	function input(){
		var p_dir = 0;
		
		if(target_timer <= 0 || ((ob.x >= target_x-8 && ob.x <= target_x+8) && (ob.y >= target_y-16 && ob.y <= target_y+16))){
				target_x = choose(32, 256-32);//irandom_range(64, 256-64);
				target_y = irandom_range(32, 240-32)
				target_timer = 256/mv_spd;
				patrol_timer = 0;
		}
		else{
			target_timer--;
		}
		
		if(patrol_timer <= 0){
			p_dir = calc_direction(target_x, target_y);
			
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