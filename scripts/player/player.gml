function player(_ob, _x, _y) : living(_ob, _x, _y) constructor{
	atk_dur = 12;
	mv_spd = 1.5;
	iframe_time = 60;
	max_health = 6;
	c_health = 6;
	max_mana = 10;
	c_mana = max_mana;
	heal_over_time = 0;
	frames_per_hp = 8;
	candle_charge = 1;
	ladder_charge = 0;
	inventory = ds_list_create();
	collected = "";
	heart_pieces = 0;
	
	keys = 0;
	bombs = 4;
	pearls = 1000;
	weapon = 0//"white_sword";
	off_hand = 1//"none";
	ds_list_add(inventory, "white_sword");
	ds_list_add(inventory, "bomb");
	//ds_list_add(inventory, off_hand); /// FOR DEBUGGING, SHOULD NOT STAY
	
	//sprites
	sprite_r = spr_link_r;
	sprite_l = spr_link_l;
	sprite_f = spr_link_f;
	sprite_b = spr_link_b;
	
	img = sprite_f;
	main_dir = "none";
	
	function input(){
		if(keyboard_check_pressed(ord("H"))){//debug button
			no_clip = !no_clip
		}
		if(keyboard_check_pressed(ord("J"))){//debug button
			sound_control.play_sound("hit");
		}
		
		var k_u = keyboard_check(ord("W")) || keyboard_check(vk_up);
		var k_d = keyboard_check(ord("S")) || keyboard_check(vk_down);
		var k_l = keyboard_check(ord("A")) || keyboard_check(vk_left);
		var k_r = keyboard_check(ord("D")) || keyboard_check(vk_right);
		
		var k_a = keyboard_check_pressed(ord("Z"));
		var k_b = keyboard_check_pressed(ord("X"));
		
		//smoooooth movement
		var only = false;
		if(k_r && !(k_l || k_d || k_u)){
			main_dir = "k_r";
			only = true;
		}
		if(k_l && !(k_r || k_d || k_u)){
			main_dir = "k_l";
			only = true;
		}
		if(k_d && !(k_l || k_r || k_u)){
			main_dir = "k_d";
			only = true;
		}
		if(k_u && !(k_l || k_d || k_r)){
			main_dir = "k_u";
			only = true;
		}
		if(!(k_l || k_r || k_d || k_u)){
			main_dir = "none";
			only = true;
		}
		
		if(k_r && (main_dir != "k_r" || only))
			request("moving", [mv_spd, 0], 1, 0);
		else if(k_d && (main_dir != "k_d" || only))
			request("moving", [0, mv_spd], 1, 0);
		else if(k_l && (main_dir != "k_l" || only))
			request("moving", [-mv_spd, 0], 1, 0);
		else if(k_u && (main_dir != "k_u" || only))
			request("moving", [0, -mv_spd], 1, 0);
		else{
			request("idle", -1, 1, 0);
			if(ob.sprite_index = sprite_r || ob.sprite_index = sprite_l){
				frm = 0;
			}
		}
		
		//abilities
		if(k_a)
			request("attacking", [inventory[| weapon]], 1, 0);
		if(k_b)
			request("attacking", [inventory[| off_hand]], 1, 0);
	}
	
	function unique_step(){
		if(instance_exists(big_fairy) && c_health < max_health && !heal_over_time){
			with(ob){
				if(slef.dir == 3 && place_meeting(x, y-16, big_fairy)){
					slef.request("stunned", [slef.frames_per_hp*(slef.max_health-slef.c_health)], 1, 4);
					//slef.c_health = slef.max_health;
					slef.heal_over_time = slef.frames_per_hp*(slef.max_health-slef.c_health);
				}
			}
		}
		if(heal_over_time > 0){
			if(heal_over_time%frames_per_hp == 0){
				c_health++;
			}
			heal_over_time--;
		}
		
		if(ladder_charge){
			var placed = false;			
			switch(dir){
				case 0:
					if(position_meeting(ob.x+9, ob.y, wall)){
						var wll = instance_position(ob.x+9, ob.y, wall);
						if(wll.sprite_index == spr_water || wll.sprite_index == spr_entrance){
							wll.laddered = true;
							placed = true;
						}
					}
					break;
				case 1:
					if(position_meeting(ob.x, ob.y+9, wall)){
						var wll = instance_position(ob.x, ob.y+9, wall);
						if(wll.sprite_index == spr_water || wll.sprite_index == spr_entrance){
							wll.laddered = true;
							placed = true;
						}
					}
					break;
				case 2:
					if(position_meeting(ob.x-9, ob.y, wall)){
						var wll = instance_position(ob.x-9, ob.y, wall);
						if(wll.sprite_index == spr_water || wll.sprite_index == spr_entrance){
							wll.laddered = true;
							placed = true;
						}
					}
					break;
				case 3:
					if(position_meeting(ob.x, ob.y-9, wall)){
						var wll = instance_position(ob.x, ob.y-9, wall);
						if(wll.sprite_index == spr_water || wll.sprite_index == spr_entrance){
							wll.laddered = true;
							placed = true;
						}
					}
					break;
			}
			if(placed){
				ladder_charge = 0;
			}
		}
		
		if(!instance_exists(sword) && !instance_exists(candle)){
			sprite_r = spr_link_r;
			sprite_l = spr_link_l;
			sprite_f = spr_link_f;
			sprite_b = spr_link_b;
		}
		else{
			sprite_r = spr_link_stab_r;
			sprite_l = spr_link_stab_l;
			sprite_f = spr_link_stab_f;
			sprite_b = spr_link_stab_b;
		}
		
		if(ent_state == "idle"){
			frm = 0;
		}
		
		if(ent_state == "moving"){
			var the_door = noone;
			with(ob){
				switch(slef.dir){
					case 0:
						if(place_meeting(x+1, y, dung_door)){
							the_door = instance_place(x+1, y, dung_door);
							if(the_door.y != y){
								the_door = noone;
							}
						}
						break;
					case 1:
						if(place_meeting(x, y+1, dung_door)){
							the_door = instance_place(x, y+1, dung_door);
							if(the_door.x != x){
								the_door = noone;
							}
						}
						if(place_meeting(x, y+1, pushblock)){
							the_door = instance_place(x, y+1, pushblock);
							if(the_door.x != x){
								the_door = noone;
							}
						}
						break;
					case 2:
						if(place_meeting(x-1, y, dung_door)){
							the_door = instance_place(x-1, y, dung_door);
							if(the_door.y != y){
								the_door = noone;
							}
						}
						break;
					case 3:
						if(place_meeting(x, y-1, dung_door)){
							the_door = instance_place(x, y-1, dung_door);
							if(the_door.x != x){
								the_door = noone;
							}
						}
						if(place_meeting(x, y-1, pushblock)){
							the_door = instance_place(x, y-1, pushblock);
							if(the_door.x != x){
								the_door = noone;
							}
						}
						break;
				}
			}
			if(the_door != noone){
				if(the_door.object_index == dung_door && keys > 0){
					if(the_door.locked && !the_door.bombable){
						mapdata.remember_lock(the_door);
						the_door.locked = false;
						keys--;
					}
				}
				else if(the_door.object_index == pushblock && !instance_exists(struct_enem)){
					the_door.push(dir);
				}
			}
		}
	}
	
	function do_die(args){
		show_message("you died");
		mapdata.jump_load_ext(mapdata.save_map_x, mapdata.save_map_y, "", 1);
		c_health = 6;
	}
	
	function do_draw(){
		var p_time = shader_get_uniform(invuln_flash, "time");
		shader_set(invuln_flash);
		shader_set_uniform_f(p_time, (invuln)&&(floor(current_time/100.0) % 2) == 0);
		
		if(collected != "" && mapdata.pause_timer > 0){
			draw_sprite(spr_link_loot_get, frm, ob.x, ob.y);
			draw_sprite(asset_get_index("spr_" + collected), 0, ob.x, ob.y-16);
		}
		else{
			draw_sprite(img, frm, ob.x, ob.y);
		}
		
		shader_reset();
	}
	
	function do_collect(args){
		var item = args[0];
	
		switch(item){//FULL items BREAK, PICKUPS need to RETURN (except bombs)
			case "map":
				with(mapdata){
					ds_list_add(collected_maps, current_map_file);
				}
				return;
			case "heart_piece":
				heart_pieces++;
				if(heart_pieces >= 4){
					max_health +=2;
					c_health = max_health;
					heart_pieces = 0;
				}
				return;
			case "compass":
				with(mapdata){
					ds_list_add(collected_compasses, current_map_file);
				}
				return;
			case "key":
				keys++;
				return;
			case "heart":
				c_health+=2;
				if(c_health > max_health){
					c_health = max_health;
				}
				return;
			case "fairy":
				c_health+=12;
				if(c_health > max_health){
					c_health = max_health;
				}
				return;
			case "bomb":
				bombs+=4;
				break;
			case "pearl":
				pearls+=args[1];
				return;
			case "tome":
				mapdata.tome_found();
				max_health += 2;
				c_health = max_health;
				return;
			case "golden_lilypad":
				ladder_charge = 1;
				break;
			case "red_potion":
			case "green_potion":
			case "blue_potion":
				var bottle_index = ds_list_find_index(inventory, "bottle");
				if(bottle_index == -1){
					return;
				}
				inventory[| bottle_index] = string_replace(item, "_potion", "_bottle");
				return;
		}
		
		if(item != "bomb" || ds_list_find_index(inventory, item) == -1){
			ds_list_add(inventory, item);
		}
	}
	
	function do_attack(args){
		if(args[0] == "none"){
			return;
		}
		
		var atk_x = dir == 0 ? 1:-1;
		var atk_y = dir == 1 ? 1:-1;
		if(args[0] == "white_sword"){
			with(instance_create_layer(ob.x + t_size*atk_x*axis, ob.y + t_size*atk_y*(!axis), "Instances", sword)){
				image_angle = !other.axis*90;
				
				if(other.dir == 1 || other.dir == 2){
					image_xscale = -1;
				}
				if(other.dir == 1){
					image_yscale = -1;
				}
				
				life = other.atk_dur;
				ob = other.ob;
				sound_control.play_sound("sword");
			}
		}
		else if(args[0] == "magic_rod"){
			with(instance_create_layer(ob.x + t_size*atk_x*axis, ob.y + t_size*atk_y*(!axis), "Instances", sword)){
				sprite_index = spr_rod;
				dmg = 3;
					
				image_angle = !other.axis*90;
				
				if(other.dir == 1 || other.dir == 2){
					image_xscale = -1;
				}
				if(other.dir == 1){
					image_yscale = -1;
				}
				
				life = other.atk_dur;
				ob = other.ob;
			}
			if(!instance_exists(magic_orb)){
				with(instance_create_layer(ob.x + t_size*atk_x*axis, ob.y + t_size*atk_y*(!axis), "Instances", magic_orb)){
					dir = other.dir;
					image_angle = !other.axis*90;
				
					if(other.dir == 1 || other.dir == 2){
						image_xscale = -1;
					}
					if(other.dir == 1){
						image_yscale = -1;
					}
				
					mv_dir = point_direction(x, y, other.ob.x, other.ob.y)+180;
					spd = 2.5;
				
					life = other.atk_dur;
					ob = other.ob;
				}
			}
		}
		else if(args[0] == "blue_candle" && candle_charge){
			candle_charge = 0;
			with(instance_create_layer(ob.x + t_size*atk_x*axis, ob.y + t_size*atk_y*(!axis), "Instances", candle)){
				image_angle = !other.axis*90;
				
				if(other.dir == 1 || other.dir == 2){
					image_xscale = -1;
				}
				if(other.dir == 1){
					image_yscale = -1;
				}
				
				life = other.atk_dur;
			}
			with(instance_create_layer(ob.x + t_size*atk_x*axis, ob.y + t_size*atk_y*(!axis), "Instances", magic_orb)){
				dir = other.dir;
				sprite_index = spr_blue_flame;
				
				mv_dir = point_direction(x, y, other.ob.x, other.ob.y)+180;
				spd = 0.5;
				
				life = other.atk_dur*2;
				ob = other.ob;
			}
		}
		else if(args[0] == "bomb" && bombs > 0){
			with(instance_create_layer(ob.x + t_size*atk_x*axis, ob.y + t_size*atk_y*(!axis), "top_layer", bomb)){
				dir = other.dir;
			}
			bombs--;
		}
		else if(args[0] == "red_bottle" || args[0] == "green_bottle" || args[0] == "blue_bottle"){
			if((args[0] == "red_bottle" && c_health == max_health) 
			|| (args[0] == "green_bottle" && c_mana == max_mana) 
			|| (args[0] == "blue_bottle" && c_health == max_health && c_mana == max_mana))
			{
				return;
			}
			
			if(inventory[| weapon] == args[0]){
				inventory[| weapon] = "bottle";
			}
			else if(inventory[| off_hand] == args[0]){
				inventory[| off_hand] = "bottle";
			}
		
			if(args[0] == "red_bottle" || args[0] == "blue_bottle"){
				c_health += 12;
				if(c_health > max_health){
					c_health = max_health;
				}
			}
			if(args[0] == "green_bottle" || args[0] == "blue_bottle"){
				c_mana += 12;
				if(c_mana > max_mana){
					c_mana = max_mana;
				}
			}
		}
		else{
			return;
		}
		
		ent_state = "stunned"
		stun_timer = atk_dur;
	}
}