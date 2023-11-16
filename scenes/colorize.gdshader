shader_type canvas_item;

uniform vec3 color = vec3(1, 1, 1);
uniform float mix_weight = 1;
uniform bool do_mix = false;

void fragment() {
    if (do_mix) {
        vec4 texture_color = texture(TEXTURE, UV);
        vec3 mixed = mix(COLOR.rgb, color, mix_weight);
        COLOR = vec4(mixed, COLOR.a);
    }
}
