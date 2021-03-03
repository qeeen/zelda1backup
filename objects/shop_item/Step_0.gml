if(req[1] != "none"){
	for(var i = 0; i < ds_list_size(mapdata.given_items); i++){
		var cur = mapdata.given_items[| i];
		if(cur[0] == req[0] && cur[1] == req[1]){
			mapdata.hide_item[order-1] = false;
			disabled = false;
			break;
		}
		else{
			mapdata.hide_item[order-1] = true;
			disabled = true;
		}
	}
	if(ds_list_size(mapdata.given_items) == 0){
		mapdata.hide_item[order-1] = true;
		disabled = true;
	}
}

if(!disabled){
	sprite_index = asset_get_index("spr_" + string(item));
}
else{
	sprite_index = spr_nothing;
}