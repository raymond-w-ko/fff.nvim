describe('fff.grep.grep_renderer', function()
  local grep_renderer = require('fff.grep.grep_renderer')

  it('renders blob-like line content with NUL bytes', function()
    local item = {
      path = '/tmp/example.txt',
      name = 'example.txt',
      extension = 'txt',
      line_number = 12,
      col = 3,
      line_content = vim.fn.eval('0z666f006f'),
    }
    local ctx = {
      win_width = 80,
      _grep_last_file = item.path,
    }

    local ok, lines = pcall(grep_renderer.render_line, item, ctx)

    assert.is_true(ok, lines)
    assert.are.same(1, #lines)
    assert.is_truthy(lines[1]:find('fo o', 1, true))
  end)
end)
