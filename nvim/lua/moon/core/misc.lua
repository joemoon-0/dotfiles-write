-- SQLI Highlighting
vim.api.nvim_create_augroup('setFileTypes', {})
vim.api.nvim_create_augroup({'BufRead', 'BufNewFile'} {
    group   = 'setFileTypes',
    pattern = '*.sqli',
    command = 'setlocal filetype=sql',
    desc    = 'Let nvim know that any file ending with the .sqli file extension is actually a SQL file'
})

-- C++ .inc Highlighting
vim.api.nvim_create_augroup({'BufRead', 'BufNewFile'} {
    group   = 'setFileTypes',
    pattern = '*.inc',
    command = 'setlocal filetype=cpp',
    desc    = 'Let nvim know that any file ending with the .inc file extension is actually a C++ file'
})

