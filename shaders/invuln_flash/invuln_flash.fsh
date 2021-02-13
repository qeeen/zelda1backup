varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform bool time;

void main()
{
	
	vec4 o_color = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 v_color = vec4(1.0, 1.0, 1.0, 1.0);
	
	if(time){
		v_color.r = abs(v_color.r - o_color.r);
		v_color.g = abs(v_color.g - o_color.g);
		v_color.b = abs(v_color.b - o_color.b);
		v_color.a = o_color.a;
	}
	else{
		v_color = o_color;
	}
	
    gl_FragColor = v_color;
}
