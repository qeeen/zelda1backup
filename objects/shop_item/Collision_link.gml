if(item == "pearl"){
	link.slef.request("collect", [item, cost], 1, 0);
	
	mapdata.paused = true;
	mapdata.pause_timer = 60;
	link.slef.collected = item;
	
	instance_destroy();
}
else if(link.slef.pearls >= cost){
	link.slef.request("collect", [item, 1], 1, 0);
	link.slef.pearls -= cost;
	
	mapdata.paused = true;
	mapdata.pause_timer = 60;
	link.slef.collected = item;
	
	instance_destroy();
}

