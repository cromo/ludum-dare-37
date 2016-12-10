uniform vec2 center;
uniform float radius;

vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen) {
  if (distance(center, uv) < radius) {
    return texture2D(texture, uv);
  }
  return vec4(1, 0, 0, 0);
}