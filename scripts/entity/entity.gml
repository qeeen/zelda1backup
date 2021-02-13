function entity(_ob, _x, _y) constructor{
	ob = _ob;
	ob.x = _x;
	ob.y = _y;
	
	img = grass;
	frm = 0;
	
	xspd = 0;
	yspd = 0;
	
	ent_state = "idle";
	requests = ds_queue_create();
	
	function request(state, args, f_wait, power){
		if(mapdata.paused){
			return;
		}
		ds_queue_enqueue(requests, [state, args, f_wait, power]);
	}
	
	function do_request(state, args){
		return;
	}
	function step(){
		show_message("test");
		return;
	}
}



















