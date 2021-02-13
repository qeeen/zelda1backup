map[0][0] = 0;
enemies[0][0] = 0;

mapx = 0;
mapy = 0;
save_map_x = mapx;
save_map_y = mapy;

mapw = 16;
maph = 16;
screenw = 16;
screenh = 15;

map_data = -1;
current_map_file = "";
cleared = true;

bg_sprite = grass;
is_dungeon = false;
unlocked_doors = ds_list_create()
collected_items = ds_list_create();
killed_enemies = ds_list_create();
destroyed_terrain = ds_list_create();

shop_mode = false;
shop_x = 0;
shop_y = 0;
entered_mapx = 0;
entered_mapy = 0;
current_map_file = "";

paused = false;
pause_timer = 0;


for(k = 0; k < 16*16; k++){
	for(i = 0; i < 15*16; i++){
		map[k][i] = "";
		enemies[k][i] = "";
	}
}

function load_map_file(filename){
	if(file_exists(filename)){
		current_map_file = filename;
		var buffer = buffer_load(filename);
		var wrapper = json_decode(buffer_read(buffer, buffer_string));
		buffer_delete(buffer);
		map_data = wrapper[? "root"];
		is_dungeon = wrapper[? "is_dungeon"];
		bg_sprite = asset_get_index(wrapper[? "bg_sprite"])
		layer_background_sprite(layer_background_get_id("Background"), bg_sprite);
		
		for(var rm = 0; rm < mapw*maph; rm++){
			var current_dat = map_data[| rm];
			var current_room = current_dat[? "tiles"];
			var current_enemies = current_dat[? "enemies"];
			
			for(var tile = 0; tile < screenw*screenh; tile++){
				map[rm][tile] = current_room[| tile];
				enemies[rm][tile] = current_enemies[| tile];
			}
		}
		
	}
	else{
		show_message("no file with this name, or you didn't put the file in the working folder idiot");
		show_message(filename);
	}
}

load_map_file("debug_ow.rm");

function check_for_scroll(){//is run in step
	if(!instance_exists(link)){
		return;
	}
	
	if(shop_mode && (link.x < 0 || link.x >= screenw*t_size || link.y < 0 || link.y >= screenh*t_size)){
			load_map();
			link.slef.candle_charge = 1;
			return;
	}
	
	var is_dif = false;
	if(link.x < 0 && !(mapx-1 < 0) && !(mapx-1 >= mapw)){
		mapx--;
		is_dif = true;
		link.x = screenw*t_size - t_sizeh;
	}
	if(link.x >= screenw*t_size && !(mapx+1 < 0) && !(mapx+1 >= mapw)){
		mapx++;
		is_dif = true;
		link.x = t_sizeh;
	}
	if(link.y < 0 && !(mapy-1 < 0) && !(mapy-1 >= maph)){
		mapy--;
		is_dif = true;
		link.y = screenh*t_size - t_sizeh;
	}
	if(link.y >= screenh*t_size && !(mapy+1 < 0) && !(mapy+1 >= maph)){
		mapy++;
		is_dif = true;
		link.y = t_sizeh;
	}
	
	if(is_dif){	
		load_map();
		link.slef.candle_charge = 1;
	}	
}

function unload_map(){
	with(wall)
		instance_destroy();
	with(struct_enem)
		instance_destroy();
	with(en_arrow)
		instance_destroy();
	with(magic_orb)
		instance_destroy();
	with(entrance)
		instance_destroy();
	with(dung_door)
		instance_destroy();
	with(explosion)
		instance_destroy();
	with(bomb)
		instance_destroy();
	with(bridge)
		instance_destroy();
	with(arch)
		instance_destroy();
	with(pickup)
		instance_destroy();
	with(shop_item)
		instance_destroy();
	with(big_fairy)
		instance_destroy();
		
	if(shop_mode){
		shop_mode = false;
		layer_background_sprite(layer_background_get_id("Background"), bg_sprite);
		link.x = shop_x;
		link.y = shop_y;
	}
}



function load_map(){
	unload_map();
	cleared = true;
	
	if(is_dungeon){
		set_dungeon_walls();
	}
	
	for(var k = 0; k < screenh; k++){
		for(var i = 0; i < screenw; i++){
			switch(map[mapx + mapy*mapw][i + k*screenw]){//tile switch
				case "w":
					var wll = instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall);
					if(is_dungeon){wll.sprite_index = spr_block}
					break;
				case "r":
					with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall)){sprite_index = spr_rock}
					break;
				case "bf":
					instance_create_layer(i*t_size + t_size, k*t_size + t_sizeh, "top_layer", big_fairy);
				case "g":
					with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall)){sprite_index = spr_grave}
					break;
				case "st":
					with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall)){sprite_index = spr_stump}
					break;
				case "l":
					with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall)){sprite_index = spr_water}
					break;
				case "k":
					with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall)){sprite_index = spr_statue}
					break;
				case "b":
					with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall)){sprite_index = spr_bush}
					break;
				case "bw":
					if(is_block_destroyed([current_map_file, mapx, mapy])){
						instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", entrance);
						break;
					}
					instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", cracked_wall);
					break;
				case "bb":
					if(is_block_destroyed([current_map_file, mapx, mapy])){
						instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", entrance);
						break;
					}
					instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", burnable_bush);
					break;
				case "m":
					instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", arch);
					break;
				case "a":
					instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", bridge);
					break;	
				case "t":
					with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", wall)){sprite_index = spr_tree}
					break;
				case "p":
					instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", pushblock);
					cleared = false;
					break;
					
				case "d":
					instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", entrance);
					break;
				case "i":
					if(is_chest_empty(current_map_file, mapx, mapy)){
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", chest)){closed = false;}
					}
					else{
						var _item = map_data[| mapx + mapy*mapw];
						_item = _item[? "item"];
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "world_tiles", chest)){item = _item;}
					}
					break;
			}
			
			var skip_enem = false;
			for(var m = 0; m < ds_list_size(killed_enemies); m++){
				current_killed = killed_enemies[| m];
				if((current_killed[0] = mapx) && (current_killed[1] = mapy) && (current_killed[2] = i) && (current_killed[3] = k)){
					skip_enem = true;
				}
			}
			
			if(!is_dungeon){// TURN THIS OFF IF YOU WANT ENEMIES TO STAY DEAD ON THE OVERWORLD
				skip_enem = false;
			}
			
			if(!skip_enem){
				switch(enemies[mapx + mapy*mapw][i + k*screenw]){																											///ENEMIES SWITCH///
					case "e":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "a":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new archer(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "g":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new ghost(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "d":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new darknut(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "m":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new gibdo(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "j":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new jiangshi(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "t":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new trap(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						break;
					case "s":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new speen(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "sk":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new skelly(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "r":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new rope(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
					case "cb":
						with(instance_create_layer(i*t_size + t_sizeh, k*t_size + t_sizeh, "Instances", struct_enem)){slef = new necromancer_boss(id, x, y); slef.init_pos = [other.mapx, other.mapy, i, k];}
						cleared = false;
						break;
				}
			}
			if(!is_dungeon){
				cleared = true;
			}
		}
	}
}

function jump_load(){
	var rm_dat = map_data[| mapx+mapy*maph];
	var dest = rm_dat[? "destination"];
	var dest_file = dest[? "map_file"] + ".rm";
	var is_local = dest[? "is_local"];
	var dest_x = dest[? "room_x"];
	var dest_y = dest[? "room_y"];
	jump_load_ext(dest_x, dest_y, dest_file, is_local);
}

function jump_load_ext(dest_x, dest_y, dest_file, is_local){
	/*var rm_dat = map_data[| mapx+mapy*maph];
	var dest = rm_dat[? "destination"];
	var is_local = dest[? "is_local"];
	var dest_file = dest[? "map_file"] + ".rm";
	var dest_x = dest[? "room_x"];
	var dest_y = dest[? "room_y"];
	*/
	
	
	//LOADING THE SHOP
	if(is_local == 2){
		var rm_dat = map_data[| mapx+mapy*maph];
		var dest = rm_dat[? "destination"];
		unload_map();
		shop_mode = true;
		layer_background_sprite(layer_background_get_id("Background"), spr_entrance);
		
		var keeper = dest[? "vendor"];
		var item1 = dest[? "item1"];
		var cost1 = dest[? "cost1"];
		var item2 = dest[? "item2"];
		var cost2 = dest[? "cost2"];
		var item3 = dest[? "item3"];
		var cost3 = dest[? "cost3"];
		
		var keeper_ob = instance_create_layer(128 - 8, 64 - 8, "Instances", bridge);
		switch(keeper){
			case "shopkeeper":
				keeper_ob.sprite_index = spr_shopkeeper;
				break;
		}
		
		if(item1 != "none")
			with(instance_create_layer(128-32 - 8, 64+32 - 8, "Instances", shop_item)){item = item1; cost = cost1;}
		if(item2 != "none")
			with(instance_create_layer(128 - 8, 64+32 - 8, "Instances", shop_item)){item = item2; cost = cost2;}
		if(item3 != "none")
			with(instance_create_layer(128+32 - 8, 64+32 - 8, "Instances", shop_item)){item = item3; cost = cost3;}
		
		shop_x = link.x;
		shop_y = link.y + 10;
		link.x = 128 - 8;
		link.y = 196 - 8;
		link.slef.candle_charge = 1;
		
		return;
	}
	
	var from_where = -1;
	if(is_local == 0){
		ds_list_clear(killed_enemies);
		if(is_dungeon){
			from_where = "dungeon";
		}
		else{
			from_where = "ow";
			entered_mapx = mapx;
			entered_mapy = mapy;
			entered_dest_file = current_map_file;
		}
		load_map_file(dest_file);
		save_map_x = dest_x;
		save_map_y = dest_y;
	}
	mapx = dest_x;
	mapy = dest_y;

	load_map();
	link.slef.candle_charge = 1;
	if(from_where == "dungeon" && instance_exists(entrance)){                        ///This code is dangerous since it assumes there will be an entrance on the other side, and not a bombable wall or something
		link.x = entrance.x;
		link.y = entrance.y + 16;
	}
	else if(from_where == "ow" && instance_exists(entrance)){
		link.x = entrance.x;
		link.y = entrance.y - 16;
	}
}

function set_dungeon_walls(){
	//corners
	with(instance_create_layer(16+0, 16+0, "world_tiles", dung_wall)){sprite_index = spr_dung_corner; image_angle = 0}
	with(instance_create_layer(16+256-32, 16+0, "world_tiles", dung_wall)){sprite_index = spr_dung_corner; image_angle = 270}
	with(instance_create_layer(16+256-32, 16+240-32, "world_tiles", dung_wall)){sprite_index = spr_dung_corner; image_angle = 180}
	with(instance_create_layer(16+0, 16+240-32, "world_tiles", dung_wall)){sprite_index = spr_dung_corner; image_angle = 90}
		
	//top row
	for(var i = 0; i < 5; i++){
		instance_create_layer(8+32 + 16*i, 16+0, "world_tiles", dung_wall);
	}
	for(var i = 0; i < 5; i++){
		instance_create_layer(16*7 + 8+32 + 16*i, 16+0, "world_tiles", dung_wall);
	}
		
	//bottom row
	for(var i = 0; i < 5; i++){
		with(instance_create_layer(8+32 + 16*i, 240-16, "world_tiles", dung_wall)){image_angle = 180};
	}
	for(var i = 0; i < 5; i++){
		with(instance_create_layer(16*7 + 8+32 + 16*i, 240-16, "world_tiles", dung_wall)){image_angle = 180};
	}
		
	//left column
	for(var i = 0; i < 5; i++){
		with(instance_create_layer(16, 8+32 + 16*i, "world_tiles", dung_wall)){image_angle = 90};
	}
	for(var i = 0; i < 4; i++){
		with(instance_create_layer(16, 16*7 + 8+32 + 16*i, "world_tiles", dung_wall)){image_angle = 90};
	}
		
	//right column
	for(var i = 0; i < 5; i++){
		with(instance_create_layer(256-16, 8+32 + 16*i, "world_tiles", dung_wall)){image_angle = 270};
	}
	for(var i = 0; i < 4; i++){
		with(instance_create_layer(256-16, 16*7 + 8+32 + 16*i, "world_tiles", dung_wall)){image_angle = 270};
	}
	
	//door stuff
	for(var i = 0; i < 4; i++){
		var room_data = map_data[| mapx + mapy*16];
		var door_data = room_data[? "dungeon_doors"];
		var current_door = "";
		var door_x = 0;
		var door_y = 0;
		var door_angle = 0;

		switch(i){
			case 0:
				current_door = door_data[? "right"];
				door_x = 256-16;
				door_y = 240/2 + 8;
				door_angle = 270;
				break;
			case 1:
				current_door = door_data[? "down"];
				door_x = 256/2;
				door_y = 240-16;
				door_angle = 180;
				break;
			case 2:
				current_door = door_data[? "left"];
				door_x = 16;
				door_y = 240/2 + 8;
				door_angle = 90;
				break;
			case 3:
				current_door = door_data[? "up"];
				door_x = 256/2;
				door_y = 16;
				door_angle = 0;
				break;
		}
		
		if(current_door == "locked" && is_door_unlocked([door_angle, current_map_file, mapx, mapy])){
			current_door = "open";
		}
		else if(current_door == "bombable" && is_door_unlocked([door_angle, current_map_file, mapx, mapy])){
			current_door = "bombed";
		}
		switch(current_door){
			case "wall":
				with(instance_create_layer(door_x, door_y, "world_tiles", dung_wall_double)){image_angle = door_angle}
				break;
			case "bombable":
				with(instance_create_layer(door_x, door_y, "top_layer", dung_door)){image_angle = door_angle; locked = true; bombable = true;}
				break;
			case "bombed":
				with(instance_create_layer(door_x, door_y, "top_layer", dung_door)){image_angle = door_angle; locked = false; bombable = true;}
				break;
			case "open":
				with(instance_create_layer(door_x, door_y, "top_layer", dung_door)){image_angle = door_angle}
				break;
			case "locked":
				with(instance_create_layer(door_x, door_y, "top_layer", dung_door)){image_angle = door_angle; locked = true;}
				break;
			case "closed":
				with(instance_create_layer(door_x, door_y, "top_layer", dung_door)){image_angle = door_angle; closed = true;}
				break;
		}
	}
}

function remember_lock(door){
	var other_angle = door.image_angle;//this stuff is to also unlock the door on the other side
	var other_mapx = mapx;
	var other_mapy = mapy;
	
	switch(door.image_angle){
		case 0:
			other_angle = 180;
			other_mapy--;
			break;
		case 90:
			other_angle = 270;
			other_mapx--;
			break;
		case 180:
			other_angle = 0;
			other_mapy++;
			break;
		case 270:
			other_angle = 90;
			other_mapx++;
			break;
	}
	var lock_data = [door.image_angle, current_map_file, mapx, mapy];
	ds_list_add(unlocked_doors, lock_data);
	lock_data = [other_angle, current_map_file, other_mapx, other_mapy];
	ds_list_add(unlocked_doors, lock_data);
}

function is_door_unlocked(lock_data){
	for(var i = 0; i < ds_list_size(unlocked_doors); i++){
		var current_lock_data = unlocked_doors[| i];
		if((current_lock_data[0] == lock_data[0]) && (current_lock_data[1] == lock_data[1]) && (current_lock_data[2] == lock_data[2]) && (current_lock_data[3] == lock_data[3])){
			return true
		}
	}
	return false;
}

function is_block_destroyed(tile_dat){
	for(var i = 0; i < ds_list_size(destroyed_terrain); i++){
		var current_lock_data = destroyed_terrain[| i];
		if((current_lock_data[0] == tile_dat[0]) && (current_lock_data[1] == tile_dat[1]) && (current_lock_data[2] == tile_dat[2])){
			return true
		}
	}
	return false;
}

function remember_chest(){//doesn't actually work for some reason, not sure why
	ds_list_add(collected_items, [current_map_file, mapx, mapy]);
}
function is_chest_empty(file, m_x, m_y){
	for(var i = 0; i < ds_list_size(collected_items); i++){
		var current_item = collected_items[| i]
		if((file == current_item[0]) && (m_x == current_item[1]) && (m_y == current_item[2])){
			return true
		}
	}
	return false;
}

function check_for_clear(){//also run in step
	if(!cleared && !instance_exists(struct_enem) && !instance_exists(pushblock)){
		cleared = true;
	}
}

function tome_found(){
	jump_load_ext(entered_mapx, entered_mapy, entered_dest_file, false);
}

function draw_shop_text(){
	draw_set_color(c_white);
	draw_set_font(f_NES_small);
	draw_set_halign(fa_center);
	
	var rm_dat = map_data[| mapx+mapy*maph];
	var dest = rm_dat[? "destination"];
	
	var cost1 = dest[? "cost1"];
	var cost2 = dest[? "cost2"];
	var cost3 = dest[? "cost3"];
	
	if(cost1 > 0)
		draw_text(128-32 - 8, 64+32, string(cost1));
	if(cost2 > 0)
		draw_text(128 - 8, 64+32, string(cost2));
	if(cost3 > 0)
		draw_text(128+32 - 8, 64+32, string(cost3));
}

function check_for_pause(){
	if(keyboard_check_pressed(vk_enter) && pause_timer <= 0){
		paused = !paused;
	}
	if(pause_timer > 0){
		pause_timer--;
		if(pause_timer <= 0){
			paused = false;
			link.slef.collected = "";
		}
	}
}

load_map();



























































