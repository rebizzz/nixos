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

const vec4 specialWorkSwitch = vec4(0.05, 0.7, 0.1, 1.0);
const float slideShare = 0.15 / 0.85;

vec4 animation(vec2 uv) {
    if (umbriel_sample(vec2(0.0005)).a > 0.0) {
        return umbriel_sample(uv);
    }
    float eased = cubicBezier(specialWorkSwitch, umbriel_linear_progress);
    float visible = umbriel_direction > 0.0 ? eased : 1.0 - eased;
    return umbriel_sample(uv - vec2(0.0, slideShare * (1.0 - visible))) * visible;
}
