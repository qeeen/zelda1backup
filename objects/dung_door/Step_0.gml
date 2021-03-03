var pos = 12;
if(locked){
	if(!bombable){
		sprite_index = locked_sprite;
	}
	else{
		sprite_index = cracked_sprite;
	}
	pos = 8;
}
else if(closed){
	sprite_index = closed_sprite;
	pos = 8;
}
else{
	if(!bombable){
		sprite_index = open_sprite;
	}
	else{
		sprite_index = bombed_sprite;
	}
}


if(mapdata.get_cave_theme() == "cave" || mapdata.bg_text == "cave"){
	open_sprite = spr_cave_d_open;
	//cracked_sprite = spr_cave_d_cracked;
	//bombed_sprite = spr_cave_d_bombed;
	//locked_sprite = spr_cave_d_locked;
	//closed_sprite = spr_cave_d_closed;
}
if(mapdata.get_cave_theme() == "house" || mapdata.bg_text == "house"){
	open_sprite = spr_house_d_open;
	//cracked_sprite = spr_house_d_cracked;
	//bombed_sprite = spr_house_d_bombed;
	//locked_sprite = spr_house_d_locked;
	//closed_sprite = spr_house_d_closed;
}


if(bombable && locked && place_meeting(x, y, explosion)){
	mapdata.remember_lock(self);
	locked = false;
}

if(mapdata.cleared){
	closed = false;
}

righty.x = x + cos(degtorad(image_angle))* (image_angle != 270 ? pos:5);
righty.y = y + sin(degtorad(image_angle))* (image_angle != 270 ? pos:5);

lefty.x = x + cos(degtorad(image_angle))*-(image_angle != 90 ? pos:5);
lefty.y = y + sin(degtorad(image_angle))*-(image_angle != 90 ? pos:5);

righty.image_angle = image_angle;
lefty.image_angle = image_angle;

img_color = mapdata.get_color();