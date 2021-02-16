if(sprite_index == spr_wall){
	if(x - 8 <= 0 || x + 8 >= 256 || y - 8 <= 0 || y + 8 >= 240){
		return;
	}
	
	if((!place_meeting(x+1, y, wall) && !place_meeting(x, y+1, wall)) && (!place_meeting(x+1, y, entrance) && !place_meeting(x, y+1, entrance))){
		sprite_index = spr_wall_diag_r;
	}
	if((!place_meeting(x-1, y, wall) && !place_meeting(x, y+1, wall)) && (!place_meeting(x-1, y, entrance) && !place_meeting(x, y+1, entrance))){
		sprite_index = spr_wall_diag_l;
	}
	if((!place_meeting(x+1, y, wall) && !place_meeting(x, y-1, wall)) && (!place_meeting(x+1, y, entrance) && !place_meeting(x, y-1, entrance))){
		image_yscale = -1;
		sprite_index = spr_wall_diag_r;
	}
	if((!place_meeting(x-1, y, wall) && !place_meeting(x, y-1, wall)) && (!place_meeting(x-1, y, entrance) && !place_meeting(x, y-1, entrance))){
		image_yscale = -1;
		sprite_index = spr_wall_diag_l;
	}
}

if(sprite_index == spr_dung_corner || sprite_index == spr_dung_wall || sprite_index == spr_dung_wall_double || sprite_index = spr_block){
	img_color = mapdata.get_color();
}

if(laddered){
	if(place_meeting(x, y, link)){
		player_on = true;
	}
	if(player_on && !place_meeting(x, y, link)){
		laddered = false;
		player_on = false;
		link.slef.ladder_charge = 1;
	}
	
	if(!place_meeting(x, y, link)){
		with(link){
			var ontop = false;
			switch(slef.dir){
				case 0:
					if(position_meeting(x+9, y, other)){
						ontop = true;
					}
					break;
				case 1:
					if(position_meeting(x, y+9, other)){
						ontop = true;
					}
					break;
				case 2:
					if(position_meeting(x-9, y, other)){
						ontop = true;
					}
					break;
				case 3:
					if(position_meeting(x, y-9, other)){
						ontop = true;
					}
					break;
			}
			if(!ontop){
				other.laddered = false;
				player_on = false;
				link.slef.ladder_charge = 1;
			}
		}
	}
}