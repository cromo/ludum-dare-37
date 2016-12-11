local planes = {}

local next_group = 1
local function add_plane(name, map, color)
  local plane = {
    map_name = map,
    color = color,
    group = next_group
  }
  next_group = next_group + 1
  planes[name] = plane
end

add_plane('reality', 'reality', {0,0,0})
add_plane('lab', 'lab', {192,192,192})
add_plane('gold', 'goald', {179,128,22})
add_plane('volcano', 'test1', {255,0,0})
add_plane('mansion', 'test2', {128,128,128})

return planes
