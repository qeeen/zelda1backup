if(closed && mapdata.cleared){
	closed = false;
	link.slef.request("collect", [item], 1, 0);
	sprite_index = spr_chest_open;
	ds_list_add(mapdata.collected_items, [mapdata.current_map_file, mapdata.mapx, mapdata.mapy]);
	mapdata.paused = true;
	mapdata.pause_timer = 60;
	link.slef.collected = item;
	//mapdata.remember_chest();
}