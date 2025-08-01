shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

#define MAXCOLORS 16

uniform bool enabled = true;
uniform bool dithering = true;
uniform int colors : hint_range(1, MAXCOLORS) = 12;
uniform int dither_size : hint_range(1, 8) = 1;

float dithering_pattern(ivec2 fragcoord) {
	const float pattern[16] = float[](
		0.00, 0.50, 0.10, 0.65,
		0.75, 0.25, 0.90, 0.35,
		0.20, 0.70, 0.05, 0.50,
		0.95, 0.40, 0.80, 0.30
	);
	int x = fragcoord.x % 4;
	int y = fragcoord.y % 4;
	return pattern[y * 4 + x];
}

float reduce_color(float raw, float dither, int depth) {
	float div = 1.0 / float(depth);
	for (int i = 0; i <= depth; i++) {
		if (raw <= div * float(i + 1)) {
			return (raw * float(depth) - float(i) <= dither * 0.999)
				? div * float(i)
				: div * float(i + 1);
		}
	}
	return 0.0;
}

void fragment() {
	vec4 raw = texture(SCREEN_TEXTURE, SCREEN_UV);
	ivec2 uv = ivec2(FRAGCOORD.xy / float(dither_size));

	if (enabled) {
		float dithering_value = dithering ? dithering_pattern(uv) : 1.0;

		COLOR.r = reduce_color(raw.r, (dithering_value - 0.5) * dithering_value + 0.5, colors - 1);
		COLOR.g = reduce_color(raw.g, (dithering_value - 0.5) * dithering_value + 0.5, colors - 1);
		COLOR.b = reduce_color(raw.b, (dithering_value - 0.5) * dithering_value + 0.5, colors - 1);
		COLOR.a = raw.a;
	} else {
		COLOR = raw;
	}
}
