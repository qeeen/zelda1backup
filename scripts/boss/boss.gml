function boss(_ob, _x, _y) : enem(_ob, _x, _y) constructor{
	murder_spd = 2;
	norm_spd = 0.8;
	mv_spd = norm_spd;
	vision_range = 64;
	max_health = 30;
	c_health = max_health;
	target_x = 0;
	target_y = 0;
	claw = instance_create_layer(ob.x, ob.y, "Instances", the_claw);
	claw.parent_ob = ob;
	claw_timer = 60;
	rush_timer = 80;
	swooce_timer = 0;
	swooce_dir = 3;
	last_hp = c_health;
	
	//sprites
	sprite_r = spr_crab_boss_r;
	sprite_l = spr_crab_boss_l;
	sprite_f = spr_crab_boss_r;
	sprite_b = spr_crab_boss_l;
	ob.mask_index = spr_crab_boss_l;
	
	function input(){
		var p_dir = 0;
		target_x = floor((256-link.x)/16)*16// + 8;
		target_y = floor((240-link.y)/16)*16// + 8;
		
		if((point_distance(ob.x, ob.y, link.x, link.y) < 32 && ob.x > link.x) || ob.x < link.x && rush_timer <= 0){
			target_x = link.x;
			target_y = link.y;
			
			if(last_hp != c_health){
				if((link.x - ob.x) > (link.y - ob.y)){
					swooce_dir = 0;
				}
				else{
					swooce_dir = 1;
				}
				swooce_timer = 80;
			}
			
			if((swooce_timer > 0 && swooce_dir == 0)){
				target_y = link.y-80;
				swooce_timer--;
			}
			if(ob.y > link.y - 32 && ob.y < link.y - 8 && (swooce_timer > 0 && swooce_dir == 1)){
				target_x = link.x-64;
				swooce_timer--;
			}
			
			mv_spd = murder_spd;
		}
		else if(ob.x < link.x){
			target_x = ob.x + 64*cos(degtorad(-point_direction(ob.x, ob.y, link.x, link.y)));//floor((256-link.x)/16)*16;
			target_y = ob.y + 64*-sin(degtorad(-point_direction(ob.x, ob.y, link.x, link.y)));//floor((240-link.y)/16)*16;
			mv_spd = murder_spd;
			rush_timer--;
		}
		else{
			rush_timer = 0;
			mv_spd = norm_spd;
			claw_timer--;
			if(claw_timer <= 0){
				claw.murder_mode = true;
				claw.murder_timer = 30;
				claw.target_x = claw.x + cos(degtorad(point_direction(claw.x, claw.y, link.x, link.y)))*256;
				claw.target_y = claw.y + -sin(degtorad(point_direction(claw.x, claw.y, link.x, link.y)))*256;
				claw_timer = claw.murder_timer+60;
			}
		}
		
		
		last_hp = c_health;
		
		if(patrol_timer <= 0){
			p_dir = calc_direction(target_x, target_y); 
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
		instance_destroy(claw);
		instance_destroy(ob);
	}
	
	function unique_step(){
		with(ob){
			if(place_meeting(x, y, link)){
				var knock_xspd = -3;
				var knock_yspd = 0;
				var knock_spd = 5;
				link.slef.request("hit", [knock_xspd*knock_spd, knock_yspd*knock_spd, 10, 2], 0, 1);
				other.rush_timer = 40;
			}
		}
	}
}

