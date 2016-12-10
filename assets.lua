local assets = {}

local is_dir = love.filesystem.isDirectory
local list_dir = love.filesystem.getDirectoryItems

local handlers = {}
function assets.register(extension, loader)
  handlers[extension:lower()] = loader
end

function assets.load(current_dir, t)
  if current_dir == nil then
    current_dir = ''
  end
  if t == nil then
    t = assets
  end

  for _, filename in ipairs(list_dir(current_dir)) do
    local full_path = current_dir .. '/' .. filename
    if is_dir(full_path) then
      t[filename] = {}
      assets.load(full_path, t[filename])
    else
      local extension = filename:gsub('.+%.(.+)', '%1'):lower()
      local name = filename:gsub('(.+)%..+', '%1')
      while name:find('%.') do
        name = name:gsub('(.+)%..+', '%1')
      end
      if handlers[extension] then
        t[name] = handlers[extension](full_path)
      end
    end
  end
end

return assets
