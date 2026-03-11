describe('fff.git_utils', function()
  local git_utils = require('fff.git_utils')
  local old_termguicolors

  before_each(function()
    old_termguicolors = vim.o.termguicolors
  end)

  after_each(function()
    vim.o.termguicolors = old_termguicolors
  end)

  it('builds selected border highlights with cterm attrs when termguicolors is disabled', function()
    vim.o.termguicolors = false

    vim.api.nvim_set_hl(0, 'FFFGitUtilsSpecBorder', { ctermfg = 3 })
    vim.api.nvim_set_hl(0, 'FFFGitUtilsSpecCursor', { ctermbg = 4 })

    local hl_opts =
      git_utils.get_selected_border_highlight_opts('FFFGitUtilsSpecBorder', 'FFFGitUtilsSpecCursor')

    assert.same({ ctermfg = 3, ctermbg = 4 }, hl_opts)

    local ok, err = pcall(vim.api.nvim_set_hl, 0, 'FFFGitUtilsSpecCombined', hl_opts)
    assert.is_true(ok, err)

    local combined = vim.api.nvim_get_hl(0, { name = 'FFFGitUtilsSpecCombined', link = false, create = false })
    assert.are.equal(3, combined.ctermfg)
    assert.are.equal(4, combined.ctermbg)
  end)

  it('resolves linked gui highlights when termguicolors is enabled', function()
    vim.o.termguicolors = true

    vim.api.nvim_set_hl(0, 'FFFGitUtilsSpecBorderBase', { fg = '#112233' })
    vim.api.nvim_set_hl(0, 'FFFGitUtilsSpecCursorBase', { bg = '#445566' })
    vim.api.nvim_set_hl(0, 'FFFGitUtilsSpecBorderLinked', { link = 'FFFGitUtilsSpecBorderBase' })
    vim.api.nvim_set_hl(0, 'FFFGitUtilsSpecCursorLinked', { link = 'FFFGitUtilsSpecCursorBase' })

    local hl_opts =
      git_utils.get_selected_border_highlight_opts('FFFGitUtilsSpecBorderLinked', 'FFFGitUtilsSpecCursorLinked')

    assert.same({ fg = tonumber('112233', 16), bg = tonumber('445566', 16) }, hl_opts)
  end)
end)
