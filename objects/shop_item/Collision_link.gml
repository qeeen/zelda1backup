if(!disabled){
	if(item == "pearl"){
		link.slef.request("collect", [item, cost], 1, 0);
	
		mapdata.paused = true;
		mapdata.pause_timer = 60;
		link.slef.collected = item;
	
		instance_destroy();
	}
	else if(link.slef.pearls >= cost){
		if((item == "blue_potion" || item == "red_potion" || item == "green_potion") && ds_list_find_index(link.slef.inventory, "bottle") == -1){
			exit;
		}
		link.slef.request("collect", [item, 1], 1, 0);
		link.slef.pearls -= cost;
	
		mapdata.paused = true;
		mapdata.pause_timer = 60;
		link.slef.collected = item;
	
		instance_destroy();
	}
}