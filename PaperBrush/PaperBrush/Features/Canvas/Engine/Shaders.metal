// BRUSH-001: Metal shaders for PaperBrush canvas rendering
#include <metal_stdlib>
using namespace metal;

// MARK: - Shared Types (must match Swift-side definitions)

// Brush type constants (must match BrushType enum rawValue order)
constant uint BRUSH_CRAYON     = 0;
constant uint BRUSH_MARKER     = 1;
constant uint BRUSH_WATERCOLOR = 2;
constant uint BRUSH_PENCIL     = 3;
constant uint BRUSH_SPRAY      = 4;
constant uint BRUSH_GLITTER    = 5;
constant uint BRUSH_STAMP      = 6;
constant uint BRUSH_ERASER     = 7;

struct StampData {
    float2 position;   // center position in canvas texture coords
    float4 color;      // RGBA
    float radius;      // stamp radius in pixels
    uint brushType;    // which brush texture to use
};

struct CanvasUniforms {
    float2 offset;
    float2 scale;
    float2 viewportSize;
    float2 canvasSize;
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

// MARK: - Noise function for brush grain

// Simple hash-based noise (fast, no texture lookup needed)
float hashNoise(float2 p) {
    float3 p3 = fract(float3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

// Smooth value noise for organic variation (watercolor edges, opacity pooling)
float valueNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f); // smoothstep interpolation
    float a = hashNoise(i);
    float b = hashNoise(i + float2(1.0, 0.0));
    float c = hashNoise(i + float2(0.0, 1.0));
    float d = hashNoise(i + float2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Fractal Brownian motion — layered noise for natural-looking variation
float fbm(float2 p, int octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < octaves; i++) {
        value += amplitude * valueNoise(p * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

// MARK: - Compute Kernel: Stamp circles with brush texture variants

kernel void stampCircles(
    texture2d<float, access::read> canvasIn [[texture(0)]],
    texture2d<float, access::write> canvasOut [[texture(1)]],
    device const StampData* stamps [[buffer(0)]],
    constant uint& stampCount [[buffer(1)]],
    constant uint4& bounds [[buffer(2)]],
    uint2 gid [[thread_position_in_grid]]
) {
    uint2 canvasPos = uint2(gid.x + bounds.x, gid.y + bounds.y);

    if (canvasPos.x >= bounds.z || canvasPos.y >= bounds.w) return;
    if (canvasPos.x >= canvasIn.get_width() || canvasPos.y >= canvasIn.get_height()) return;

    float2 pixelCenter = float2(canvasPos) + 0.5;
    float4 existing = canvasIn.read(canvasPos);

    for (uint i = 0; i < stampCount; i++) {
        float dist = distance(pixelCenter, stamps[i].position);
        float radius = stamps[i].radius;
        uint brushType = stamps[i].brushType;

        // Apply brush-specific radius multiplier
        float effectiveRadius = radius;
        if (brushType == BRUSH_MARKER)     effectiveRadius = radius * 1.2;
        if (brushType == BRUSH_WATERCOLOR) effectiveRadius = radius * 2.0;
        if (brushType == BRUSH_PENCIL)     effectiveRadius = radius * 0.5;

        if (dist >= effectiveRadius) continue;

        float4 stampColor = stamps[i].color;
        float alpha = stampColor.a;
        float normalizedDist = dist / effectiveRadius;

        // Brush-specific rendering
        if (brushType == BRUSH_CRAYON) {
            // Crayon: waxy grain, semi-transparent so overlaps build up visibly
            float edge = 1.0 - smoothstep(0.5, 0.85, normalizedDist);
            // Multi-scale grain for realistic waxy texture
            float grain1 = hashNoise(pixelCenter * 0.3);
            float grain2 = hashNoise(pixelCenter * 1.2 + 37.0);
            float grain = grain1 * 0.6 + grain2 * 0.4;
            // Paper showing through — ~25% of pixels are holes
            float grainMask = step(0.25, grain);
            // Lower base opacity (0.45) so overlap areas get visibly darker/richer
            alpha *= edge * 0.45 * grainMask * mix(0.5, 1.0, grain);

        } else if (brushType == BRUSH_MARKER) {
            // Marker: smooth, semi-transparent, hard flat edges
            float edge = 1.0 - smoothstep(0.85, 1.0, normalizedDist);
            alpha *= edge * 0.7;

        } else if (brushType == BRUSH_WATERCOLOR) {
            // Watercolor: very soft feathered edges, dramatic opacity variation, paper grain

            // Strong organic edge distortion — warps boundary for irregular bleed
            float edgeWarp1 = fbm(pixelCenter * 0.06 + stamps[i].position * 0.015, 4);
            float edgeWarp2 = valueNoise(pixelCenter * 0.12 + 53.0);
            float warpedDist = normalizedDist + (edgeWarp1 - 0.5) * 0.45 + (edgeWarp2 - 0.5) * 0.15;

            // Ultra-soft feathered falloff — lots of bleed at edges
            float edge = 1.0 - smoothstep(0.05, 0.85, warpedDist);

            // Pigment pooling — more opaque overall to minimize replay visual differences
            float pooling = fbm(pixelCenter * 0.04 + 17.0, 3);
            float opacityVariation = mix(0.10, 0.35, pooling); // higher base opacity

            // Edge darkening — pigment concentrates at stroke edges (capillary effect)
            float edgeDarkening = smoothstep(0.3, 0.7, warpedDist) * 0.06;
            opacityVariation += edgeDarkening * edge;

            // Paper grain texture — visible granular feel like wet paper
            float paperGrain = hashNoise(pixelCenter * 0.6);
            float fineGrain = hashNoise(pixelCenter * 2.0 + 91.0);
            float grainEffect = mix(0.55, 1.0, paperGrain * 0.7 + fineGrain * 0.3);

            alpha *= edge * opacityVariation * grainEffect;

        } else if (brushType == BRUSH_PENCIL) {
            // Pencil: fine, light, slight grain
            float edge = 1.0 - smoothstep(0.7, 1.0, normalizedDist);
            float grain = hashNoise(pixelCenter * 1.5);
            alpha *= edge * 0.4 * mix(0.7, 1.0, grain);

        } else {
            // Default (spray, glitter, stamp, eraser): soft circle
            float edge = 1.0 - smoothstep(0.7, 1.0, normalizedDist);
            alpha *= edge;
        }

        // Alpha blend: src-over compositing
        existing = float4(
            existing.rgb * (1.0 - alpha) + stampColor.rgb * alpha,
            existing.a + alpha * (1.0 - existing.a)
        );
    }

    canvasOut.write(existing, canvasPos);
}

// MARK: - Vertex Shader: Fullscreen quad with canvas transform

vertex VertexOut canvasVertex(
    uint vertexID [[vertex_id]],
    constant CanvasUniforms& uniforms [[buffer(0)]]
) {
    float2 positions[4] = {
        float2(-1.0, -1.0),
        float2( 1.0, -1.0),
        float2(-1.0,  1.0),
        float2( 1.0,  1.0),
    };

    float2 texCoords[4] = {
        float2(0.0, 1.0),
        float2(1.0, 1.0),
        float2(0.0, 0.0),
        float2(1.0, 0.0),
    };

    float2 pos = positions[vertexID];

    float2 ndcOffset = float2(
        (uniforms.offset.x / uniforms.viewportSize.x) * 2.0,
        -(uniforms.offset.y / uniforms.viewportSize.y) * 2.0
    );
    pos = pos * uniforms.scale + ndcOffset;

    VertexOut out;
    out.position = float4(pos, 0.0, 1.0);
    out.texCoord = texCoords[vertexID];
    return out;
}

// MARK: - Fragment Shader: Sample canvas texture

fragment float4 canvasFragment(
    VertexOut in [[stage_in]],
    texture2d<float> canvasTexture [[texture(0)]]
) {
    constexpr sampler texSampler(mag_filter::linear, min_filter::linear,
                                  address::clamp_to_edge);
    float4 color = canvasTexture.sample(texSampler, in.texCoord);

    // Composite over white background (the "page")
    float3 background = float3(1.0, 1.0, 1.0);
    float3 result = color.rgb + background * (1.0 - color.a);
    return float4(result, 1.0);
}
