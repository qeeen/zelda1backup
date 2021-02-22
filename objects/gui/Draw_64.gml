//touhou bg thing
draw_sprite_part(spr_the_background, 0, 0, 0, 80*3, 1200, 0, 0);
draw_sprite_part(spr_the_background, 0, 1920-80*5, 0, 80*5, 1200, 1920-80*5, 0);

draw_set_font(f_NES);

draw_set_halign(fa_center);

//pause
if(mapdata.paused && mapdata.pause_timer <= 0){
	draw_set_valign(fa_center);
	var pause_w = 320;
	var pause_h = 80;
	var half_w = window_get_width()/2;
	var half_h = window_get_height()/2;
	draw_set_color(c_black);
	draw_rectangle(half_w-pause_w/2, half_h-pause_h/2, half_w+pause_w/2, half_h+pause_h/2, 0);
	draw_set_color(c_white);
	draw_text(half_w, half_h, "-PAUSED-");
	draw_set_valign(fa_top);
}

//-LIFE-
draw_set_color(c_white);
draw_text((80*3)/2, 128, "-LIFE-");

//hearts
var m_health = 0;
var c_health = 0;
if(instance_exists(link)){
	m_health = link.slef.max_health;
	c_health = link.slef.c_health;
}

var xbse = (80*3)/2 - 24 - 48;
var ybse = 176;
for(var i = 0; i < m_health/2; i++){
	if(c_health < (i+1)*2){
		if(c_health+1 == (i+1)*2){
			draw_sprite_ext(spr_hud_heart_half, 0, xbse + (i%4)*48, ybse + (floor(i/4))*48, 5, 5, 0, c_white, 1);
		}
		else{
			draw_sprite_ext(spr_hud_heart_empty, 0, xbse + (i%4)*48, ybse + (floor(i/4))*48, 5, 5, 0, c_white, 1);
		}
	}
	else{
		draw_sprite_ext(spr_hud_heart, 0, xbse + (i%4)*48, ybse + (floor(i/4))*48, 5, 5, 0, c_white, 1);
	}
}

//lamp oil, rope, bombs
ybse = 416;
draw_set_halign(fa_left);
draw_sprite_ext(spr_hud_bomb, 0, xbse, ybse, 5, 5, 0, c_white, 1);
draw_text(xbse + 64, ybse, string(link.slef.bombs));
ybse += 96;
draw_sprite_ext(spr_hud_key, 0, xbse, ybse, 5, 5, 0, c_white, 1);
draw_text(xbse + 64, ybse, string(link.slef.keys));
ybse += 96;
draw_sprite_ext(spr_hud_pearl, 0, xbse, ybse, 5, 5, 0, c_white, 1);
draw_text(xbse + 64, ybse, string(link.slef.pearls));

//equipped item slots
ybse = 780
draw_set_halign(fa_center);
draw_text(xbse+8, ybse, "A");
draw_text(xbse+128, ybse, "B");
draw_set_color(c_black);
draw_rectangle(xbse - 40, ybse+32, xbse+56, ybse+192, 0);
draw_rectangle(xbse+80, ybse+32, xbse+80 + 96, ybse+192, 0);

function find_sprite_name(name){
	switch(name){
		case "white_sword":
			return spr_white_sword;
			break;
		case "blue_candle":
			return spr_blue_candle;
			break;
		case "bomb":
			return spr_bomb;
			break;
		case "magic_rod":
			return spr_magic_rod;
			break;
		case "golden_lilypad":
			return spr_golden_lilypad;
			break;
		default:
			return spr_entrance;
			break;
	}
}

var a_sprite = find_sprite_name(link.slef.weapon);
var b_sprite = find_sprite_name(link.slef.off_hand);
draw_sprite_ext(a_sprite, 0, xbse - 40 + 48, ybse+32 + 48 + 24, 5, 5, 0, c_white, 1);
draw_sprite_ext(b_sprite, 0, xbse+80 + 48, ybse+32 + 48 + 24, 5, 5, 0, c_white, 1);

//inventory
xbse = 1920-80*5 + 16;
ybse = 64;

draw_set_font(f_NES);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(xbse + (4*80 + 5*10)/2, ybse - 32, "-ITEMS-");

if(mapdata.paused && mapdata.pause_timer <= 0){
	var pos_min = 0;
	var pos_max = ds_list_size(link.slef.inventory)-1;
	
	if(keyboard_check_pressed(vk_right)){
		cursor_i++;
	}
	if(keyboard_check_pressed(vk_down)){
		cursor_i+=4;
	}
	if(keyboard_check_pressed(vk_left)){
		cursor_i--;
	}
	if(keyboard_check_pressed(vk_up)){
		cursor_i-=4;
	}
	cursor_i = clamp(cursor_i, pos_min, pos_max);
	
	if(keyboard_check_pressed(ord("Z"))){
		if(link.slef.off_hand == link.slef.inventory[| cursor_i]){
			link.slef.off_hand = link.slef.weapon;
		}
		link.slef.weapon = link.slef.inventory[| cursor_i];
	}
	if(keyboard_check_pressed(ord("X"))){
		if(link.slef.weapon == link.slef.inventory[| cursor_i]){
			link.slef.weapon = link.slef.off_hand;
		}
		link.slef.off_hand = link.slef.inventory[| cursor_i];
	}
}
else{
	cursor_i = -1;
}

draw_set_color(c_black);
draw_rectangle(xbse, ybse, xbse + 4*80 + 5*10, ybse+7*80 + 8*10, 0);

for(var i = 0; i < ds_list_size(link.slef.inventory); i++){
	var k = floor(i/4);
	var mod_i = i%4;
	draw_sprite_ext(find_sprite_name(link.slef.inventory[| i]), 0, xbse + 10*(mod_i+1) + 40 + 80*mod_i, ybse + 10*(k+1) + 40 + 80*k, 5, 5, 0, c_white, 1);
	
	if(i == cursor_i){
		draw_sprite_ext(spr_selection, 0, xbse + 10*(mod_i+1) + 40 + 80*mod_i, ybse + 10*(k+1) + 40 + 80*k, 5, 5, 0, c_white, 1);
	}
}

//map
ybse += 7*80 + 8*10 + 40;
draw_set_font(f_NES);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(xbse+(4*80 + 5*10)/2, ybse, "-MAP-");

ybse += 40;
var scale = 23;
draw_set_color(c_black);
draw_rectangle(xbse, ybse, xbse + scale*16, ybse + scale*16, 0);
for(var i = 0; i < mapdata.mapw*mapdata.maph; i++){
	if(mapdata.ui_map[i] >= 1){
		draw_set_color(c_dkgrey);
		if(mapdata.mapx + mapdata.mapy*mapdata.mapw == i){
			draw_set_color(make_color_rgb(135, 22, 70));
		}

		var xpos = xbse+(scale*(i%16));
		var ypos = ybse+(scale*floor(i/16));
		
		if(mapdata.is_map_found() || !mapdata.is_dungeon){
			draw_rectangle(xpos, ypos, xpos+scale, ypos+scale, 0);
		}
		
		if(mapdata.is_compass_found() || !mapdata.is_dungeon){
			switch(mapdata.ui_map[i]){
				case 2:
					draw_sprite_ext(spr_ui_chest, 0, xpos + scale/2, ypos + scale/2, scale/16, scale/16, 0, c_white, 1);
					break;
				case 3:
					draw_sprite_ext(spr_skull, 0, xpos + scale/2, ypos + scale/2, scale/16, scale/16, 0, c_white, 1);
					break;
				case 4:
					draw_sprite_ext(spr_ui_gate, 0, xpos + scale/2, ypos + scale/2, scale/16, scale/16, 0, c_white, 1);
					break;
			}
		}
	}
}











































