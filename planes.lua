local assets = require 'assets'

local function init()
  local planes = {}

  local next_group = 1
  local function add_plane(name, map, color, key, anchor)
    local plane = {
      name = name,
      map_name = map,
      color = color,
      group = next_group,
      key_image = assets[key].image,
      anchor_detail = assets[anchor].image
    }
    next_group = next_group + 1
    planes[name] = plane
  end

  add_plane('reality', 'reality', {59,9,76}, 'key', 'anchor_detail_white')
  add_plane('lab', 'lab', {52,152,219}, 'key', 'anchor_detail_white')
  add_plane('gold', 'goald', {249,179,47}, 'key', 'anchor_detail_white')
  add_plane('volcano', 'test1', {207,124,4}, 'key', 'anchor_detail_white')
  add_plane('mansion', 'test2', {169,155,181}, 'key', 'anchor_detail_white')

  return planes
end

return init
