shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx, unshaded;

uniform vec4 color : source_color;
uniform float color_intensity = 1000.0;
uniform float transparency_level = 10.0;
uniform float speed = 6.0;
uniform float zoom_amplitude = 0.3;
float circle (vec2 position){
	return 1.0 - float(distance(position, vec2(0.5)) > 0.5);
}

void fragment() {
	ALPHA = pow(length(UV - vec2(0.5)),transparency_level + zoom_amplitude * sin(TIME * speed)) * circle(UV);
	ALBEDO.rgb = color.rgb * color_intensity;
}
