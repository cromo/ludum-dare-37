uniform vec2 center;
uniform float radius;
uniform float t;

vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen) {
  float base_frequency = uv.y + t + center.x + center.y;
  float horizontal_offset =
      0.046 * radius * sin(base_frequency * 1337) +
      0.016 * radius * sin(base_frequency * 13) +
      0.016 * radius * sin(base_frequency * 7);
  vec2 displaced_point = uv;
  displaced_point.x += horizontal_offset;
  if (distance(center, displaced_point) < radius) {
    return texture2D(texture, uv);
  }
  return vec4(1, 0, 0, 0);
}