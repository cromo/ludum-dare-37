return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 24,
  height = 24,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "Volcano",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "volcano-tiles.png",
      imagewidth = 80,
      imageheight = 48,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 15,
      tiles = {
        {
          id = 0,
          properties = {
            ["collidable"] = true,
            ["sensor"] = false
          }
        },
        {
          id = 1,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 2,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 3,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 4,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 5,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 7,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 8,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 9,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 10,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 11,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 12,
          properties = {
            ["collidable"] = true
          }
        }
      }
    },
    {
      name = "Bottomless Pit",
      firstgid = 16,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "the-pits.png",
      imagewidth = 80,
      imageheight = 48,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 15,
      tiles = {
        {
          id = 6,
          properties = {
            ["sensor"] = true
          }
        }
      }
    },
    {
      name = "Lurva",
      firstgid = 31,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "lava-pit.png",
      imagewidth = 48,
      imageheight = 48,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 9,
      tiles = {
        {
          id = 4,
          properties = {
            ["sensor"] = true
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 24,
      height = 24,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 22, 22, 22, 1, 2, 2, 2, 2, 3, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 22, 22, 22, 6, 16, 17, 17, 18, 8, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 22, 22, 22, 6, 21, 22, 22, 23, 8, 0, 0, 0,
        6, 7, 7, 31, 32, 32, 33, 7, 7, 7, 7, 8, 22, 22, 22, 6, 21, 22, 22, 23, 8, 0, 0, 0,
        6, 7, 7, 34, 35, 35, 36, 7, 7, 7, 7, 8, 22, 22, 22, 6, 21, 22, 22, 23, 8, 0, 0, 0,
        6, 7, 7, 37, 38, 38, 39, 7, 7, 7, 7, 5, 2, 2, 2, 4, 21, 22, 22, 23, 8, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 31, 32, 32, 33, 7, 7, 7, 7, 7, 16, 19, 22, 22, 23, 8, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 34, 35, 35, 36, 7, 7, 7, 7, 7, 21, 22, 22, 22, 23, 5, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 34, 35, 35, 36, 7, 7, 7, 7, 7, 21, 22, 22, 22, 23, 7, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 34, 35, 35, 36, 7, 7, 7, 7, 7, 21, 22, 22, 22, 23, 7, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 37, 38, 38, 39, 7, 7, 7, 7, 7, 21, 22, 22, 22, 23, 7, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 21, 22, 22, 22, 23, 10, 0, 0, 0,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 26, 27, 27, 27, 28, 8, 0, 0, 0,
        11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
