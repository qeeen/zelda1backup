function living(_ob, _x, _y) : entity(_ob, _x, _y) constructor{
	
	stun_timer = 0;
	axis = 1;
	prev_axis = axis;
	dir = 0;
	offset = 0;
	
	//sprites
	sprite_r = grass;
	sprite_l = grass;
	sprite_f = grass;
	sprite_b = grass;
	
	//stats
	mv_spd = t_sizeq/4;
	max_health = 8;
	c_health = max_health;
	invuln = false;
	iframe_time = 30;
	no_clip = false;
	
	function do_request(state, args){
		if(ent_state = "stunned" && stun_timer > 0 && state != "stunned" && state != "iframes" && state != "collect"){
			return 1;
		}
	
		switch(state){
			case "moving":
				do_moving(args);
				break;
			case "idle":
				do_idle(args);
				break;
			case "stunned":
				do_stunned(args);
				break;
			case "attacking":
				do_attack(args);
				break;
			case "hurt":
				do_hurt(args);
				break;
			case "die":
				do_die(args);
				break;
			case "knocked":
				do_knockback(args);
				break;
			case "iframes":
				do_iframes(args);
				break;
			case "hit":
				do_hit(args);
				break;
			case "collect":
				do_collect(args);
				break;
		}
		
		return 0;
	}
	
	function do_collect(args){
		return;
	}
	
	function do_attack(args){
		return;
	}
	
	function do_hit(args){
		if(!invuln){
			request("hurt", [args[3]], 1, 2);
			request("knocked", args, 0, 1);
		}
	}
	
	function do_hurt(args){
		if(!invuln){
			c_health -= args[0];
			request("iframes", [iframe_time], 1, 0);
			if(c_health <= 0){
				request("die", -1, 1, 1);
			}
		}
	}
	
	function do_iframes(args){
		invuln = true;
		if(args[0] <= 0){
			invuln = false;
		}
		else{
			request("iframes", [args[0]-1], 0, 4);
		}
	}
	
	function do_die(args){
		instance_create_layer(ob.x, ob.y, "Instances", death_anim);
		instance_destroy(ob);
	}
	
	function do_knockback(args){
		var x_sped = args[0];
		var y_sped = args[1]
		var durat = args[2];
		
		/*if(ent_state == "forced" && durat == iframe_time){
			return;
		}*/
		
		if((axis == 1 && x_sped != 0) || (axis == 0 && y_sped != 0)){
			ent_state = "forced";
			do_moving([x_sped, y_sped]);
			ent_state = "forced";
			if(durat >= 0)
				request("knocked", [x_sped, y_sped, durat-1], 0, 2);
			else
				request("idle", -1, 1, 1);
		}
		
	}
	
	function do_moving(args){
		var no_dir = false;
		var last_dir = 0;
		if(ent_state == "forced"){
			no_dir = true;
			last_dir = dir;
		}
		
		ent_state = "moving";
		xspd = args[0];
		yspd = args[1];
				
		if(xspd > 0){
			dir = 0;
			axis = 1;
		}
		if(yspd > 0){
			dir = 1;
			axis = 0;
		}
		if(xspd < 0){
			dir = 2;
			axis = 1;
		}
		if(yspd < 0){
			dir = 3;
			axis = 0;
		}
		
		if(no_dir){
			dir = last_dir;
		}
				
		if(prev_axis != axis){
			if(axis == 1){
				ob.y -= ob.y%t_sizeq;
				if(ob.y%t_sizeh != 0){
					ob.y+=t_sizeq;
				}
			}
			else{
				ob.x -= ob.x%t_sizeq;
				if(ob.x%t_sizeh != 0){
					ob.x+=t_sizeq;
				}
			}
		}
				
		//this code is embarressing, but it works
		var collides = false;
		with(ob){
			if(other.no_clip){
				break;
			}
			//the mario 64 method, check each quarter of movement, to prevent easily clipping walls
			for(var i = 1; i <= 4; i++){
				var collided = ds_list_create();
				var onto = ds_list_create();
				
				instance_place_list(x+i*(other.xspd)/4.0, y+i*(other.yspd)/4.0, wall, collided, 0);
				instance_place_list(x, y, wall, onto, 0);
				
				for(var k = 0; k < ds_list_size(collided); k++){
					var is_onto = false;
					if(collided[| k].laddered || (!collided[| k].visible && collided[| k].object_index == chest)){
						is_onto = true;
					}
					for(var m = 0; m < ds_list_size(onto); m++){
						if(collided[| k] == onto[| m]){
							is_onto = true;
							break;
						}	
					}
					if(is_onto){
						continue;
					}
										
					collides = true;
					other.xspd = i*(other.xspd)/4.0
					other.yspd = i*(other.yspd)/4.0
					break;
				}
				ds_list_destroy(collided);
				ds_list_destroy(onto);
				
				if(no_dir){//keeps the player from being knocked out of the room
					if((x+i*(other.xspd)/4.0 >= 248) || (y+i*(other.yspd)/4.0 >= 232) || (x+i*(other.xspd)/4.0 < 0) || (y+i*(other.yspd)/4.0 < 0)){
						collides = true;
						other.xspd = i*(other.xspd)/4.0
						other.yspd = i*(other.yspd)/4.0
						break;
					}
				}
			}
		}
		
		if(collides){
			ob.x+=xspd;
			ob.y+=yspd;
			ob.x-=ob.x%t_sizeq;
			ob.y-=ob.y%t_sizeq;
			if(ob.x%t_sizeh != 0)
				ob.x+=t_sizeq;
			if(ob.y%t_sizeh != 0)
				ob.y+=t_sizeq;
			xspd = 0;
			yspd = 0;
		}
				
		prev_axis = axis;
	}
	
	function do_idle(args){
		ent_state = "idle";
	}
	
	function do_stunned(args){
		ent_state = "stunned";
		stun_timer = args[0];
	}
	
	function input(){
		return;
	}
	
	function do_draw(){
		var p_time = shader_get_uniform(invuln_flash, "time");
		shader_set(invuln_flash);
		shader_set_uniform_f(p_time, (invuln)&&(floor(current_time/100.0) % 2) == 0);
		
		draw_sprite(img, frm, ob.x, ob.y);
		
		shader_reset();
	}
	
	function step(){
		if(mapdata.paused){
			return;
		}
		if(ent_state != "forced")
			input();
		
		var skipped_reqs = ds_stack_create();
		sort_queue(requests);
		
		while(!ds_queue_empty(requests)){
			var req = ds_queue_dequeue(requests);
			
			if(req[2] == 1)
				do_request(req[0], req[1]);
			else{
				req[2] = 1;
				ds_stack_push(skipped_reqs, req);
			}
		}

		switch(ent_state){
			case "idle":
				xspd = 0;
				yspd = 0;
				break;
			case "moving":
				ob.x += xspd;
				ob.y += yspd;
				break;
			case "stunned":
				stun_timer--;
				xspd = 0;
				yspd = 0;
				break;
			case "forced":
				ob.x += xspd;
				ob.y += yspd;
				break;
		}
		calc_sprite();
		unique_step();
		
		while(!ds_stack_empty(skipped_reqs)){
			ds_queue_enqueue(requests, ds_stack_pop(skipped_reqs));
		}
		ds_stack_destroy(skipped_reqs);
	}
	
	function unique_step(){
		return;
	}
	
	function calc_sprite(){
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
			
		if(ent_state == "moving" || ent_state == "forced"){
			frm = (current_time/(100/ob.image_speed))%sprite_get_number(img)
		}
	}
	
	function sort_queue(q){
		var holder = ds_list_create();
		while(!ds_queue_empty(q)){
			ds_list_add(holder, ds_queue_dequeue(q));
		}
		
		for(var i = 1; i < ds_list_size(holder); i++){
			for(var k = i; k > 0; k--){
				var this_dat = holder[| k];
				var prev_dat = holder[| k-1];
				
				if(this_dat[3] < prev_dat[3]){
					var temp = holder[| k-1];
					holder[| k-1] = holder[| k];
					holder[| k] = temp;
				}
				else
					break;
			}
		}
		for(var i = 0; i < ds_list_size(holder); i++){
			ds_queue_enqueue(q, holder[| i]);
		}
	}
	
}