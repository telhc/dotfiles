call plug#begin()

" Appearance
" Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Smooth Scrolling
Plug 'yuttie/comfortable-motion.vim'
" theme
Plug 'dylanaraps/wal.vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" Utility
"Plug 'preservim/nerdtree'
Plug 'natecraddock/workspaces.nvim'
Plug 'natecraddock/sessions.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'easymotion/vim-easymotion'
Plug 'jalvesaq/colorout'
Plug 'airblade/vim-gitgutter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'jpalardy/vim-slime'

" Language
Plug 'neovim/nvim-lspconfig'
Plug 'jalvesaq/Nvim-R'
Plug 'lervag/vimtex'
"Plug 'luk400/vim-jukit'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
"Plug 'ncm2/ncm2'
"Plug 'roxma/nvim-yarp'
"Plug 'ncm2/ncm2-bufword'
"Plug 'ncm2/ncm2-path'
"Plug 'ncm2/ncm2-cssomni'
""Plug 'ncm2/ncm2-tern'
"Plug 'ncm2/ncm2-jedi'
"Plug 'gaalcaras/ncm-R'
Plug 'tmhedberg/SimpylFold'
call plug#end()

" Vim settings
set number
set relativenumber
set colorcolumn=80
"set tabstop=4
set shiftwidth=2 smarttab
au BufNewFile,BufRead *.ejs set filetype=html

" Slime settings
let g:slime_target = "x11"

" Airline theme (requires powerline-fonts)
let g:airline_theme = 'violet'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0

" theme
lua <<EOF
  require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
  })
vim.cmd.colorscheme "catppuccin"
EOF

" LSP
:luado require("lspconfig").pyright.setup{}
:luado require("lspconfig").cssls.setup{}
:luado require("lspconfig").eslint.setup{}
:luado require("lspconfig").html.setup{}
:luado require("lspconfig").vuels.setup{}

" treesitter
:luado require("nvim-treesitter.configs").setup{highlight={enable=true}}

" Workspaces & Session setup
:luado require("workspaces").setup({hooks = {open = { "NvimTreeOpen", "Telescope find_files" }}})
":luado require("sessions").setup()
:luado require("telescope").load_extension("workspaces")
:luado require("telescope").setup({defaults={path_display = { truncate = 3 } }})
":luado require("telescope").setup({extensions = {workspaces = {keep_insert = false}}})
nnoremap <Leader>w :Telescope workspaces<CR>

" Bufferline Settings
set termguicolors
:luado require("bufferline").setup{}

" nvim-tree setup
:luado vim.g.loaded_netrw = 1
:luado vim.g.loaded_netrwPlugin = 1
:luado vim.opt.termguicolors = true
:luado require("nvim-tree").setup()

:luado local async = require "plenary.async"


" Completion Settings
" enable ncm2 for all buffers
"autocmd BufEnter * call ncm2#enable_for_buffer()
"" IMPORTANT: :help Ncm2PopupOpen for more information
"set completeopt=noinsert,menuone,noselect
"
"set shortmess+=c
"inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
EOF

" Vsnip mappings
noremap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'


" Bindings Mappings
" basic
noremap <Leader>h :noh<CR>
nnoremap <C-PageUp> :bp<CR>
nnoremap <C-P> :bp<CR>
nnoremap <C-PageDown> :bn<CR>
nnoremap <C-N> :bn<CR>
nnoremap <C-X> :bd<CR>

" reload
nnoremap <Leader><Leader>rl :source ~/.config/nvim/init.vim<CR>
" EasyMotion
map <S-j> <Plug>(easymotion-bd-f)
" Telescope
map t :Telescope<CR>
map <C-O> :Telescope find_files<CR>
map <F8> :Telescope grep_string<CR>
" Folding
nnoremap <Leader>f :foldclose<CR>
" NvimTree
noremap <F3> :NvimTreeToggle<CR>
" Window Settings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-I> <C-W>s<C-W>H
" Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize -3<CR>
noremap <silent> <C-Down> :resize +3<CR>
" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tv <C-w>t<C-w>K
" Markdown preview
let g:mkdp_auto_start = 0
map <Leader>md <Plug>MarkdownPreviewToggle
" Jukit
let g:jukit_mappings = 0
nnoremap <leader>np :call jukit#convert#notebook_convert("jupyter-notebook")<cr>
" R enter
let R_assign = 0
function! s:customNvimRMappings()
   noremap <buffer> <CR> <Plug>RDSendLine
endfunction
augroup myNvimR
   au!
   autocmd filetype r call s:customNvimRMappings()
augroup end
" vimtex settings
filetype plugin indent on
syntax enable
let g:vimtex_view_method = 'general'
nnoremap <Leader>ll <Plug>(vimtex-compile)

