var p_time = shader_get_uniform(invuln_flash, "time");
shader_set(invuln_flash);
shader_set_uniform_f(p_time, (fuse < 20)&&(floor(current_time/50.0) % 2) == 0);
		
draw_self();
		
shader_reset();