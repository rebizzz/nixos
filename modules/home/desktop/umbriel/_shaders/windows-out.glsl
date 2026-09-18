float bezierAxis(float t, float p1, float p2) {
    float u = 1.0 - t;
    return 3.0 * u * u * t * p1 + 3.0 * u * t * t * p2 + t * t * t;
}

float bezierSlope(float t, float p1, float p2) {
    float u = 1.0 - t;
    return 3.0 * u * u * p1 + 6.0 * u * t * (p2 - p1) + 3.0 * t * t * (1.0 - p2);
}

float newtonStep(vec4 points, float x, float t) {
    float slope = max(bezierSlope(t, points.x, points.z), 1e-3);
    return clamp(t - (bezierAxis(t, points.x, points.z) - x) / slope, 0.0, 1.0);
}

float cubicBezier(vec4 points, float x) {
    x = clamp(x, 0.0, 1.0);
    float t = x;
    t = newtonStep(points, x, t);
    t = newtonStep(points, x, t);
    t = newtonStep(points, x, t);
    t = newtonStep(points, x, t);
    t = newtonStep(points, x, t);
    t = newtonStep(points, x, t);
    return bezierAxis(t, points.y, points.w);
}

// Must match animation.windows_out.duration_ms; alpha uses its curve via umbriel_progress.
const float durationMs = 600.0;
const vec4 emphasizedAccel = vec4(0.3, 0.0, 0.8, 0.15);

vec4 animation(vec2 uv) {
    float elapsedMs = umbriel_linear_progress * durationMs;
    float shrink = cubicBezier(emphasizedAccel, elapsedMs / 300.0);
    vec2 scale = max(mix(umbriel_size, vec2(5.0), shrink), vec2(5.0)) / umbriel_size;
    return umbriel_sample((uv - 0.5) / scale + 0.5) * (1.0 - umbriel_clamped_progress);
}
