if(!closed){
	visible = true;
	sprite_index = spr_chest_open;
}
else if(!mapdata.cleared){
	visible = false;
}
else{
	visible = true;
}
/*
if(item == "tome"){
	sprite_index = spr_tome;
}*/