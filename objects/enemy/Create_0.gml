ent_state = "idle";
stun_timer = 0;
xspd = 0;
yspd = 0;
requests = ds_queue_create();

patrol_timer = 0;
mv_spd = t_sizeq/4;
last_req = ["idle", -1];

function request(state, args){
	ds_queue_enqueue(requests, [state, args]);
}

function do_request(state, args){
	if(ent_state = "stunned" && stun_timer > 0 && state != "stunned"){
		return 1;
	}
	
	switch(state){
		case "moving":
			ent_state = "moving";
			xspd = args[0];
			yspd = args[1];
			break;
		case "idle":
			ent_state = "idle";
			break;
		case "stunned":
			ent_state = "stunned";
			stun_timer = args[0];
			break;
	}
	
	return 0;
}

function ai_step(){
	var dir = 0;
	if(patrol_timer == 0){
		dir = irandom_range(0, 4);
		switch(dir){
			case 0:
				last_req = ["idle", -1];
				request(last_req[0], last_req[1]);
				break;
			case 1:
				last_req = ["moving", [mv_spd, 0]];
				request(last_req[0], last_req[1]);
				break;
			case 2:
				last_req = ["moving", [0, mv_spd]];
				request(last_req[0], last_req[1]);
				break;
			case 3:
				last_req = ["moving", [-mv_spd, 0]];
				request(last_req[0], last_req[1]);
				break;
			case 4:
				last_req = ["moving", [0, -mv_spd]];
				request(last_req[0], last_req[1]);
				break;
		}
		
		patrol_timer = irandom_range(15, 45);
	}
	else{
		request(last_req[0], last_req[1]);
	}
	
	if(ent_state != "stunned"){
		patrol_timer--;
	}
}