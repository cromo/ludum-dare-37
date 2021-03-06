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
  nextobjectid = 18,
  properties = {},
  tilesets = {
    {
      name = "white-walls",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "white-walls.png",
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
            ["collidable"] = false
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
            ["collidable"] = false
          }
        },
        {
          id = 14,
          properties = {
            ["collidable"] = false
          }
        }
      }
    },
    {
      name = "holes",
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
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10, 12, 12, 12, 12, 12, 12, 12, 12, 13, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 1, 2, 2, 2, 2, 2, 2, 2, 3, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 5, 4, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 11, 9, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 2, 4, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10, 12, 12, 12, 12, 12, 12, 12, 9, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 1, 2, 2, 2, 2, 2, 3, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 8, 6, 16, 17, 17, 17, 18, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 8, 6, 26, 27, 27, 27, 28, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 8, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 4, 7, 7, 7, 7, 7, 5, 4, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 16, 18, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 21, 20, 18, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 21, 22, 23, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 26, 27, 28, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8,
        11, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 13
      }
    },
    {
      type = "objectgroup",
      name = "game_elements",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "key",
          shape = "rectangle",
          x = 360,
          y = 417,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "mansion",
            ["to"] = "mansion"
          }
        },
        {
          id = 3,
          name = "",
          type = "key",
          shape = "rectangle",
          x = 360,
          y = 463,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "lab",
            ["to"] = "mansion"
          }
        },
        {
          id = 6,
          name = "",
          type = "anchor",
          shape = "ellipse",
          x = 325,
          y = 328,
          width = 194,
          height = 194,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "lab"
          }
        },
        {
          id = 9,
          name = "",
          type = "anchor",
          shape = "ellipse",
          x = 347,
          y = 236,
          width = 192,
          height = 192,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "mansion"
          }
        },
        {
          id = 10,
          name = "",
          type = "key",
          shape = "rectangle",
          x = 407,
          y = 313,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "mansion",
            ["to"] = "volcano"
          }
        },
        {
          id = 11,
          name = "",
          type = "anchor",
          shape = "ellipse",
          x = 175,
          y = 119,
          width = 401,
          height = 401,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "volcano"
          }
        },
        {
          id = 12,
          name = "",
          type = "anchor",
          shape = "ellipse",
          x = 416,
          y = 151,
          width = 105,
          height = 105,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "mansion"
          }
        },
        {
          id = 13,
          name = "",
          type = "anchor",
          shape = "ellipse",
          x = -22,
          y = -247,
          width = 773,
          height = 773,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "mansion"
          }
        },
        {
          id = 14,
          name = "",
          type = "key",
          shape = "rectangle",
          x = 440,
          y = 42,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "mansion",
            ["to"] = "volcano"
          }
        },
        {
          id = 15,
          name = "",
          type = "anchor",
          shape = "ellipse",
          x = 66,
          y = 307,
          width = 192,
          height = 192,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "volcano"
          }
        },
        {
          id = 16,
          name = "",
          type = "key",
          shape = "rectangle",
          x = 225,
          y = 198,
          width = 19,
          height = 19,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "mansion",
            ["to"] = "gold"
          }
        },
        {
          id = 17,
          name = "",
          type = "anchor",
          shape = "ellipse",
          x = -59,
          y = 112,
          width = 310,
          height = 310,
          rotation = 0,
          visible = true,
          properties = {
            ["start"] = "volcano"
          }
        }
      }
    }
  }
}
