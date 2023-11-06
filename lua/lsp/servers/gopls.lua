local settings = {
  gopls = {
    codelenses = { vendor = false },
    analyses = { bools = true },
  },
}

return function()
  return {
    settings = settings,
  }
end
