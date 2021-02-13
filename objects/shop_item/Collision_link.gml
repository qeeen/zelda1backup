if(link.slef.pearls >= cost){
	link.slef.request("collect", [item, 1], 1, 0);
	link.slef.pearls -= cost;
	instance_destroy();
}