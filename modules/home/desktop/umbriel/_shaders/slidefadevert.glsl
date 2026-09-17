vec4 animation(vec2 uv) {
    float visible = umbriel_direction > 0.0
        ? umbriel_clamped_progress : 1.0 - umbriel_clamped_progress;
    return umbriel_sample(uv + vec2(0.0, 0.15 * (1.0 - visible))) * visible;
}
