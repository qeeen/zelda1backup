if(link.y >= y+(door_offset-8) && link.x > x+(door_offset-8) && link.x < x+(door_width+door_offset-8)){
	hitbox.x = -100;
}
else{
	hitbox.x = x;
}

hitbox.sprite_index = sprite_index;
hitbox.mask_index = mask_index;