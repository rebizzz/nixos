float bezierAxis(float t, float p1, float p2) {
    float u = 1.0 - t;
    return 3.0 * u * u * t * p1 + 3.0 * u * t * t * p2 + t * t * t;
}

float cubicBezier(vec4 points, float x) {
    x = clamp(x, 0.0, 1.0);
    float low = 0.0;
    float high = 1.0;
    float t = x;
    for (int i = 0; i < 24; i++) {
        if (bezierAxis(t, points.x, points.z) < x) {
            low = t;
        } else {
            high = t;
        }
        t = 0.5 * (low + high);
    }
    return bezierAxis(t, points.y, points.w);
}

const float durationMs = 600.0;
const vec4 emphasizedDecel = vec4(0.05, 0.7, 0.1, 1.0);
const vec4 standard = vec4(0.2, 0.0, 0.0, 1.0);

vec4 animation(vec2 uv) {
    float elapsedMs = umbriel_linear_progress * durationMs;
    float grow = cubicBezier(emphasizedDecel, elapsedMs / 500.0);
    float alpha = cubicBezier(standard, elapsedMs / 600.0);
    vec2 scale = max(umbriel_size * grow, vec2(5.0)) / umbriel_size;
    return umbriel_sample((uv - 0.5) / scale + 0.5) * alpha;
}
