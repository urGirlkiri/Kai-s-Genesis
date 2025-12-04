shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(0.4, 0.25, 0.1, 1.0);

uniform float depletion_progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	
	vec3 new_color = mix(current_pixel.rgb, target_color.rgb, depletion_progress);
	
	COLOR = vec4(new_color, current_pixel.a);
}