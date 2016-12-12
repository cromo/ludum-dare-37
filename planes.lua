local assets = require 'assets'

local function init()
  local planes = {}

  local next_group = 1
  local function add_plane(name, map, color, key, anchor)
    local plane = {
      map_name = map,
      color = color,
      group = next_group,
      key_image = assets[key].image,
      anchor_detail = assets[anchor].image
    }
    next_group = next_group + 1
    planes[name] = plane
  end

  add_plane('reality', 'reality', {0,0,0}, 'key', 'anchor_detail_white')
  add_plane('lab', 'lab', {255,255,255}, 'key', 'anchor_detail_white')
  add_plane('gold', 'goald', {179,128,22}, 'key', 'anchor_detail_white')
  add_plane('volcano', 'test1', {255,0,0}, 'key', 'anchor_detail_white')
  add_plane('mansion', 'test2', {128,28,108}, 'key', 'anchor_detail_white')

  return planes
end

return init
