ai_step();

while(!ds_queue_empty(requests)){
	var req = ds_queue_dequeue(requests);
	do_request(req[0], req[1]);
}

switch(ent_state){
	case "idle":
		xspd = 0;
		yspd = 0;
		break;
	case "moving":
		x += xspd;
		y += yspd;
		break;
	case "stunned":
		stun_timer--;
		xspd = 0;
		yspd = 0;
		break;
}