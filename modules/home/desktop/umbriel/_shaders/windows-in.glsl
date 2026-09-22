// Instant Fluid Pop-in with Hyprshade-inspired selective vibrance sheen
// Highly optimized: 1 texture sample, zero loops, zero memory buffers.

vec4 animation(vec2 uv) {
    float progress = umbriel_clamped_progress;

    // Fast tight scale (0.95 -> 1.0) so window is instantly clear and readable
    float scale = max(mix(0.95, 1.0, umbriel_progress), 0.05);

    // Centered coordinates
    vec2 centeredUv = (uv - vec2(0.5)) / scale + vec2(0.5);
    vec4 color = umbriel_sample(centeredUv);

    // Hyprshade-style selective vibrance enhancement on entry:
    float maxC = max(color.r, max(color.g, color.b));
    float minC = min(color.r, min(color.g, color.b));
    float sat = maxC - minC;
    float sheen = 0.15 * sin(3.14159265 * progress) * (1.0 - progress);

    vec3 enrichedRgb = mix(color.rgb, color.rgb * (1.0 + (1.0 - sat) * 0.35), sheen);

    // Fast-onset alpha ramp so content is immediately readable from frame 1
    float alpha = mix(0.35, 1.0, progress);
    return vec4(enrichedRgb, color.a) * alpha;
}
