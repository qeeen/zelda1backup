instance_create_layer(x, y, "world_tiles", entrance);
ds_list_add(mapdata.destroyed_terrain, [mapdata.current_map_file, mapdata.mapx, mapdata.mapy]);
instance_destroy();