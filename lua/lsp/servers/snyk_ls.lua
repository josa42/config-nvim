local settings = {
  filetypes = { 'javascript', 'typescript', 'go', 'python', 'terraform', 'helm', 'dockerfile' },
  init_options = {
    activateSnykCode = 'true',
    activateSnykIac = 'true',
    activateSnykOpenSource = 'true',
    additionalParams = '--all-projects',
    enableTrustedFoldersFeature = 'false',
    integrationName = 'neovim',
    filterSeverity = { critical = true, high = true, medium = true, low = true },
    organization = 'Cision',
    token = '259b43f6-604e-4b14-a5a5-24a517d87c8b',
  },
}

return function()
  return settings
end
