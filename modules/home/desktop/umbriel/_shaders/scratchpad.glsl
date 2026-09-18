// Hyprland "slidefadevert 15%": rise in from below, sink out, fading with the slide.
const float slideShare = 0.15 / 0.85;

vec4 animation(vec2 uv) {
    // The backdrop dim shares this shader; its opaque corner tells it apart from rounded windows.
    if (umbriel_sample(vec2(0.0005)).a > 0.0) {
        return umbriel_sample(uv);
    }
    float visible = umbriel_direction > 0.0 ? umbriel_clamped_progress : 1.0 - umbriel_clamped_progress;
    return umbriel_sample(uv - vec2(0.0, slideShare * (1.0 - visible))) * visible;
}
