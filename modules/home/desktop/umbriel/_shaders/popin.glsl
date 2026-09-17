vec4 animation(vec2 uv) {
    float visible = umbriel_direction > 0.0
        ? umbriel_clamped_progress : 1.0 - umbriel_clamped_progress;
    float scale = mix(0.8, 1.0, visible);
    return umbriel_sample((uv - 0.5) / scale + 0.5) * visible;
}
