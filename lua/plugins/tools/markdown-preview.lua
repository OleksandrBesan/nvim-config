return {
  'iamcco/markdown-preview.nvim',
  keys = { { '<leader><f8>', '<cmd> MarkdownPreviewToggle <CR>' } },
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = 'markdown',
  build = 'cd app && npm install'
}
