locked = false;
closed = false;
bombable = false;
img_color = mapdata.get_color();

lefty = instance_create_layer(x-4, y, "Instances", invis_wall);
righty = instance_create_layer(x+4, y, "Instances", invis_wall);

bg = instance_create_layer(x, y, "world_tiles", black_square);