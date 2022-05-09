local M = {}

local file_icon = {
  icon = '',
}

function M.set_default_icon() end
function M.set_icon() end
function M.set_up_highlights() end
function M.setup() end

function M.get_icon()
  return file_icon.icon
end
function M.get_icon_by_filetype()
  return file_icon.icon
end

function M.get_icon_colors()
  return nil
end

function M.get_icon_colors_by_filetype()
  return nil
end

function M.get_icon_color()
  return nil
end

function M.get_icon_color_by_filetype()
  return nil
end

function M.get_icon_cterm_color()
  return nil
end

function M.get_icon_cterm_color_by_filetype()
  return nil
end

function M.get_icon_name_by_filetype()
  return 'Default'
end

function M.get_icons()
  return {}
end

function M.has_loaded()
  return true
end

return M
