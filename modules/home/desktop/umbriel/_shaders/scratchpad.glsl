// Silky Vertical Slide-In with Backdrop Dim Protection
// Zero texture leakage, smooth hermite easing.

const float slideShare = 0.12;

vec4 animation(vec2 uv) {
    // Backdrop dim detection: full-screen backdrop has opaque corners, window does not
    if (umbriel_sample(vec2(0.0005)).a > 0.0) {
        return umbriel_sample(uv);
    }

    float visible = umbriel_direction > 0.0 ? umbriel_clamped_progress : 1.0 - umbriel_clamped_progress;
    float smoothVis = smoothstep(0.0, 1.0, visible);

    // Vertical slide offset (smooth entrance from above)
    float yOffset = slideShare * (1.0 - smoothVis);
    return umbriel_sample(uv - vec2(0.0, yOffset)) * smoothVis;
}
