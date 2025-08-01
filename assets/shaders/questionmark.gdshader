shader_type spatial;

uniform sampler2D icon;
uniform vec4 marker_color : source_color;
uniform float color_intensity = 1.0;
render_mode cull_disabled, unshaded, blend_add;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			MAIN_CAM_INV_VIEW_MATRIX[0],
			MAIN_CAM_INV_VIEW_MATRIX[1],
			MAIN_CAM_INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec4 color = texture(icon, UV);
	ALBEDO = marker_color.rgb * color_intensity;
	ALPHA = color.a;
}

