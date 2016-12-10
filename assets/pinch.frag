uniform vec2 center;
uniform float radius;
uniform float t;

vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen) {
  float phase = uv.y + t + center.x + center.y;
  float horizontal_offset =
      0.046 * radius * sin(phase * 1337) +
      0.016 * radius * sin(phase * 13) +
      0.016 * radius * sin(phase * 7);
  uv.x = uv.x + horizontal_offset;
  if (distance(center, uv) < radius) {
    return texture2D(texture, uv);
  }
  return vec4(1, 0, 0, 0);
}