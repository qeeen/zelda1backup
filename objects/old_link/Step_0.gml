k_u = keyboard_check(vk_up);
k_d = keyboard_check(vk_down);
k_l = keyboard_check(vk_left);
k_r = keyboard_check(vk_right);

k_z = keyboard_check_pressed(ord("Z"));

if(!stun_timer){
	if(k_u){
		dir = 3;
		atk_y = -1;
		axis = 0;
	}
	else if(k_l){
		dir = 2;
		atk_x = -1;
		axis = 1;
	}
	else if(k_d){
		dir = 1;
		atk_y = 1;
		axis = 0;
	}
	else if(k_r){
		dir = 0;
		atk_x = 1;
		axis = 1;
	}
}


if((axis != axis_prev) && !stun_timer){
	if(axis == 1)
		posy += sign(offset)*(abs(offset) > t_sizeq ? t_sizeh : 0);
	if(axis == 0)
		posx += sign(offset)*(abs(offset) > t_sizeq ? t_sizeh : 0);
		
	offset = 0;
}

if(!(place_meeting(posx + t_sizeh, posy, wall) && k_r) 
&& !(place_meeting(posx - t_sizeh, posy, wall) && k_l) 
&& !(place_meeting(posx, posy + t_sizeh, wall) && k_d) 
&& !(place_meeting(posx, posy - t_sizeh, wall) && k_u)
&& !(stun_timer)
)
{
	if(k_u || k_l)
		offset -= spd;
	else if (k_d || k_r)
		offset += spd;
}

if((offset > t_sizeh || offset < -t_sizeh) && !stun_timer){
	offset = clamp(offset, -t_sizeh, t_sizeh);
	if(axis == 1){
		posx += t_sizeh*sign(offset);
	}
	else{
		posy += t_sizeh*sign(offset);
	}
	offset = 0;
}

if(axis == 1){
	x = posx + offset;
	y = posy;
} 
else {
	x = posx;
	y = posy + offset;
}

if(k_z && !stun_timer){
	with(
	instance_create_layer(x + t_size*atk_x*axis, y + t_size*atk_y*(!axis), "Instances", sword)){
		image_angle = !other.axis*90;
		life = other.atk_dur;
		ob = other.id;
	}
	attacking = true;
	stun_timer = atk_dur;
}

if(stun_timer > 0){
	stun_timer--;
	if(stun_timer == 0){
		attacking = false;
	}
}

axis_prev = axis;