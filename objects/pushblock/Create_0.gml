pushtimer = 0;
pushed = false;
spd = 0;
laddered = false;

function push(dir){
	if(pushed)
		return;
	pushed = true;
	
	if(dir == 1){
		spd = 2;
	}
	if(dir == 3){
		spd = -2;
	}
	pushtimer = 8;
	mapdata.cleared = true;
}

