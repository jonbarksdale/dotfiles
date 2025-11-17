return {
  "3rd/diagram.nvim",
  dependencies = {
    "3rd/image.nvim",
  },
  opts = {
    renderer_options = {
      mermaid = {
        background = nil,
        theme = nil,
        scale = 1,
        width = nil,
        height = nil,
      },
      plantuml = {
        charset = nil,
      },
      d2d = {
        theme_id = nil,
        dark_theme_id = nil,
        scale = nil,
        layout = nil,
        sketch = nil,
      },
      gnuplot = {
        size = nil,
        font = nil,
        theme = nil,
      },
    },
  },
}
