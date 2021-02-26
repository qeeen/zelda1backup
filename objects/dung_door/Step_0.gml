var pos = 12;
if(locked){
	if(!bombable){
		sprite_index = spr_dung_d_locked;
	}
	else{
		sprite_index = spr_dung_d_cracked;
	}
	pos = 8;
}
else if(closed){
	sprite_index = spr_dung_d_closed;
	pos = 8;
}
else{
	if(!bombable){
		sprite_index = spr_dung_d_open;
	}
	else{
		sprite_index = spr_dung_d_bombed;
	}
}

if(mapdata.shop_mode){
	sprite_index = spr_cave_d_open;
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