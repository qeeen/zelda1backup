function trap(_ob, _x, _y) : enem(_ob, _x, _y) constructor{
	patrol_timer = 0;
	last_req = ["idle", -1];
	murder_spd = 2;
	back_spd = 0.5;
	mv_spd = murder_spd;
	atk_dur = 15;
	anchor_x = ob.x;
	anchor_y = ob.y;
	seen = false;
	backtrack = false;
	
	//sprites
	sprite_r = spr_trap;
	sprite_l = spr_trap;
	sprite_f = spr_trap;
	sprite_b = spr_trap;
	
	function input(){
		var p_dir = 0;
		
		var approaching = false;
		if(ent_state != "idle"){
			with(ob){
				switch(slef.dir){
					case 0:
						if(place_meeting(x+1, y, wall) || x+9 >= 256){
							approaching = true;
						}
						break;
					case 1:
						if(place_meeting(x, y+1, wall) || y+9 >= 240){
							approaching = true;
						}
						break;
					case 2:
						if(place_meeting(x-1, y, wall) || x-9 <= 0){
							approaching = true;
						}
						break;
					case 3:
						if(place_meeting(x, y-1, wall) || y-9 <= 0){
							approaching = true;
						}
						break;
				}
			}
		}
		if(approaching || (point_distance(ob.x, ob.y, anchor_x, anchor_y) >= 88)){
			backtrack = true;
			seen = false;
		}
		
		
		
		if((backtrack) || (!seen && ((link.x >= ob.x-8 && link.x <= ob.x+8) || (link.y >= ob.y-8 && link.y <= ob.y+8)))){
			if(!seen && !backtrack && ((link.x >= ob.x-8 && link.x <= ob.x+8) || (link.y >= ob.y-8 && link.y <= ob.y+8))){
				seen = true;
				if(instance_exists(link)){
					var p_dir = calc_direction(link.x, link.y);
				}
				mv_spd = murder_spd;
			}
			if(backtrack){
				var p_dir = calc_direction(anchor_x, anchor_y);
				mv_spd = back_spd;
				
				if(ob.x >= anchor_x-4 && ob.x <= anchor_x+4 && ob.y >= anchor_y-4 && ob.y <= anchor_y+4){
					backtrack = false;
					ob.x = anchor_x;
					ob.y = anchor_y;
					p_dir = 0;
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
		return;
		
		if(!invuln){
			request("hurt", [args[3]], 1, 2);
			request("knocked", args, 0, 1);
		}
	}
	
	function unique_step(){
		hit_on_touch();
	}
}