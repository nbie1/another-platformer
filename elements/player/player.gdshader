shader_type canvas_item;
render_mode blend_add;

uniform vec4 glow_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float glow_power: hint_range(0.0, 8.0, 0.1) = 1.9;
uniform float glow_shift: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float glow_radius: hint_range(1.0, 10.0, 0.1) = 1.0;

void fragment() {
	vec4 glow = vec4(0.0);
	float count = 0.0;
	for (float i = -glow_radius; i <= glow_radius; i += 1.0) {
		for (float j = -glow_radius; j <= glow_radius; j += 1.0) {
			vec2 offset = vec2(i, j) * glow_shift * TEXTURE_PIXEL_SIZE;
			glow += texture(TEXTURE, UV + offset) * glow_color;
			count++;
		}
	}
	glow *= glow_power / count;
	COLOR = mix(texture(TEXTURE, UV), glow, glow.a);
} 
 