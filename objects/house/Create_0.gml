hitbox = instance_create_layer(x, y, "Instances", wall);
hitbox.visible = false;
hitbox.sprite_index = sprite_index;
hitbox.mask_index = mask_index;

door_offset = 16;
door_width = 16;