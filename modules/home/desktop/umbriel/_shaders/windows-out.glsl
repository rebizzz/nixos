// Smooth Receding Depth Exit & Dissolve
// Highly optimized: single texture sample, no loops, zero memory allocations.

vec4 animation(vec2 uv) {
    float progress = umbriel_clamped_progress;
    float alpha = 1.0 - progress;

    // Window shrinks subtly from 1.0 to 0.94 as it recedes
    float scale = max(mix(1.0, 0.94, progress), 0.05);

    vec2 centeredUv = (uv - vec2(0.5)) / scale + vec2(0.5);
    vec4 color = umbriel_sample(centeredUv);

    // Soft luminance falloff as the window dissolves into depth
    float depthFade = mix(1.0, 0.88, progress);

    // Strictly premultiplied RGBA
    return vec4(color.rgb * depthFade, color.a) * alpha;
}
