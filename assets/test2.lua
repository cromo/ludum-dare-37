return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 32,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "mansion-walls",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "mansion-walls.png",
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
            ["collidable"] = true
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
      name = "Mansion Floor",
      firstgid = 16,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "mansion-carpet.png",
      imagewidth = 80,
      imageheight = 48,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 15,
      tiles = {}
    },
    {
      name = "The Pits",
      firstgid = 31,
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
          id = 0,
          properties = {
            ["collidable"] = true
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
          id = 6,
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
        },
        {
          id = 13,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 14,
          properties = {
            ["collidable"] = true
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
      width = 32,
      height = 32,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 21, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 23, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 21, 22, 19, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 20, 22, 23, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 21, 22, 23, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 21, 22, 23, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 21, 22, 23, 7, 7, 31, 32, 32, 32, 33, 7, 7, 7, 7, 21, 22, 23, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 21, 22, 23, 7, 7, 36, 37, 37, 37, 38, 7, 7, 7, 7, 21, 22, 23, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        8, 7, 21, 22, 23, 7, 7, 36, 37, 37, 37, 38, 7, 7, 7, 7, 21, 22, 23, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        8, 7, 21, 22, 23, 7, 7, 36, 37, 37, 37, 38, 7, 7, 7, 7, 21, 22, 23, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        8, 7, 21, 22, 23, 7, 7, 36, 40, 42, 39, 38, 7, 16, 18, 7, 21, 22, 23, 7, 8, 6, 31, 32, 32, 32, 32, 32, 32, 32, 33, 8,
        8, 7, 21, 22, 23, 7, 7, 41, 43, 7, 41, 43, 7, 26, 28, 7, 26, 27, 28, 7, 8, 6, 41, 42, 42, 42, 42, 42, 42, 42, 43, 8,
        6, 7, 26, 27, 28, 7, 10, 12, 12, 12, 12, 12, 9, 31, 32, 32, 32, 32, 33, 10, 13, 6, 7, 21, 22, 22, 22, 22, 22, 23, 7, 8,
        6, 7, 7, 7, 7, 7, 5, 2, 2, 2, 2, 2, 4, 41, 42, 42, 42, 42, 43, 5, 2, 4, 7, 26, 27, 27, 27, 27, 27, 28, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 16, 17, 18, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 21, 22, 23, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 21, 22, 23, 7, 7, 7, 7, 31, 32, 33, 10, 12, 12, 12, 12, 13,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 21, 22, 23, 7, 31, 32, 32, 34, 40, 43, 5, 2, 2, 2, 2, 3,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 26, 20, 24, 18, 36, 7, 40, 42, 43, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10, 12, 9, 7, 7, 7, 7, 21, 22, 23, 36, 7, 38, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 37, 6, 7, 7, 7, 7, 21, 22, 23, 41, 42, 43, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 37, 6, 7, 7, 7, 7, 21, 22, 23, 10, 12, 9, 7, 10, 12, 12, 12, 12, 12, 12, 13,
        6, 7, 16, 17, 18, 7, 16, 17, 18, 7, 8, 37, 6, 7, 7, 7, 7, 21, 22, 23, 5, 2, 4, 7, 5, 2, 2, 2, 2, 2, 2, 3,
        6, 7, 21, 22, 23, 7, 21, 22, 23, 7, 8, 37, 11, 9, 10, 12, 9, 21, 22, 23, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 26, 27, 28, 7, 26, 27, 28, 7, 8, 37, 37, 6, 8, 37, 6, 21, 22, 23, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 2, 2, 4, 5, 2, 4, 21, 22, 24, 17, 17, 18, 7, 7, 16, 17, 18, 7, 7, 7, 8,
        6, 7, 16, 17, 18, 7, 16, 17, 18, 7, 7, 7, 7, 7, 7, 7, 7, 21, 22, 22, 22, 22, 23, 7, 7, 21, 22, 23, 7, 7, 7, 8,
        6, 7, 21, 22, 23, 7, 21, 22, 23, 7, 7, 7, 7, 7, 7, 7, 7, 26, 27, 27, 27, 27, 28, 7, 7, 26, 27, 28, 7, 7, 7, 8,
        6, 7, 26, 27, 28, 7, 26, 27, 28, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13
      }
    }
  }
}
