" ############################################################
" #### Custom
" ############################################################
" leader
let mapleader = "\<Space>"

" completion with Tab
inoremap <expr><CR> pumvisible() ? '<C-y>' : '<CR>'
inoremap <expr><Tab> pumvisible() ? '<C-n>' : '<C-t>'
inoremap <expr><S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" terminal
nnoremap <silent><Leader>t :cal popup_create(term_start([&shell],#{hidden:1,term_finish:'close'}),#{border:[],minwidth:&columns*3/4,minheight:&lines*3/4})<CR>
nnoremap <silent><Leader>g :cal popup_create(term_start(['lazygit'],#{hidden:1,term_finish:'close'}),#{border:[],minwidth:&columns*3/4,minheight:&lines*3/4})<CR>

" row visual
nnoremap vv ^v$h

" insert move
inoremap <C-l> <C-o>l
inoremap {{ <C-o>A{}<C-o>h

" ############################################################
" #### PLUGINS
" ############################################################
call plug#begin()

" ### Enhanced vim motion
Plug 'serna37/vim-modern-basic'
Plug 'serna37/vim-anchor5'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-edgemotion'
Plug 'rhysd/clever-f.vim'
Plug 'serna37/vim-fscope-around'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/vim-asterisk'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'simeji/winresizer'
Plug 'yuttie/comfortable-motion.vim'
nnoremap <C-h> ^<Plug>(anchor)
nnoremap <C-l> $<Plug>(anchor)
let g:EasyMotion_do_mapping = 0
nnoremap s <Plug>(easymotion-sn)
nnoremap <Leader><Leader>w <Plug>(easymotion-bd-w)
nnoremap <C-j> <Plug>(edgemotion-j)<Plug>(anchor)
nnoremap <C-k> <Plug>(edgemotion-k)<Plug>(anchor)
let g:clever_f_smart_case = 1
let g:clever_f_timeout_ms = 2000
let g:clever_f_highlight_timeout_ms = 2000
aug cleaver_f
    au!
    au ColorScheme * hi CleverFDefaultLabel cterm=bold,underline ctermfg=9 ctermbg=24
aug END
nnoremap <leader>w <Plug>(fscope-around-toggle)<Plug>(clever-f-reset)
nnoremap # <Plug>(asterisk-z*)<Plug>(quickhl-manual-this)
nnoremap <silent><Leader>q <Plug>(quickhl-manual-reset)<Plug>(clever-f-reset):noh<CR>
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_interval = 1000.0 / 60
let g:comfortable_motion_friction = 70.0
let g:comfortable_motion_air_drag = 5.0
nnoremap <silent><C-f> :cal comfortable_motion#flick(200)<CR>
nnoremap <silent><C-b> :cal comfortable_motion#flick(-200)<CR>

" ### Enhanced Visualization
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/goyo.vim'
Plug 'liuchengxu/vim-which-key'
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
fu! s:moveBuf(flg) abort
    let current_id = ''
    let buf_arr = []
    for v in split(execute('ls'), '\n')->map({ _,v -> split(v, ' ')})
        let x = copy(v)->filter({ _,v -> !empty(v) })
        if stridx(x[1], 'F') == -1 && stridx(x[1], 'R') == -1
            cal add(buf_arr, x[0])
            if stridx(x[1], '%') != -1
                let current_id = x[0]
            endif
        endif
    endfor
    let buf_idx = a:flg == 'next' ? match(buf_arr, current_id) + 1 : match(buf_arr, current_id) - 1
    let buf_id = buf_idx == len(buf_arr) ? buf_arr[0] : buf_arr[buf_idx]
    exe 'b '.buf_id
endf

fu! s:closeBuf() abort
    let now_b = bufnr('%')
    cal s:moveBuf('prev')
    execute('bd ' . now_b)
endf

noremap <silent><Plug>(buf-prev) :<C-u>cal <SID>moveBuf('prev')<CR>
noremap <silent><Plug>(buf-next) :<C-u>cal <SID>moveBuf('next')<CR>
noremap <silent><Plug>(buf-close) :<C-u>cal <SID>closeBuf()<CR>
nnoremap <C-n> <Plug>(buf-prev)
nnoremap <C-p> <Plug>(buf-next)
nnoremap <Leader>x <Plug>(buf-close)
nnoremap <silent><Leader>z :Goyo<CR>
nnoremap <silent><Leader> :WhichKey '<Space>'<CR>
set timeoutlen=500

" ### Filer
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'TwoDark'
nnoremap <silent><Leader>f :cal execute('CocCommand fzf-preview.'.(system('git rev-parse --is-inside-work-tree') =~ 'fatal'?'DirectoryFiles':'ProjectFiles'))<CR>
nnoremap <silent><Leader>b :CocCommand fzf-preview.Buffers<CR>
nnoremap <silent><Leader>hf :CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent><Leader>e :CocCommand explorer --width 30<CR>
nnoremap <silent><Leader>s :CocCommand fzf-preview.Lines<CR>
nnoremap <silent><Leader><Leader>s :CocCommand fzf-preview.ProjectGrep .<CR>
nnoremap <silent><Leader>m :CocCommand fzf-preview.Bookmarks<CR>
nnoremap <silent><Leader>nn :CocCommand fzf-preview.MemoList<CR>
nnoremap <silent><Leader>ng :CocCommand fzf-preview.MemoListGrep .<CR>
au DirChanged * cal execute('CocCommand explorer --no-focus --width 30')

" ### Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" ### Reading
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'andymass/vim-matchup'
Plug 'preservim/vim-indent-guides'
Plug 'liuchengxu/vista.vim'
Plug 'wfxr/minimap.vim'
au VimEnter * RainbowParentheses
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_exclude_filetypes = ['help', 'coc-explorer', 'startify']
let g:indent_guides_auto_colors = 0
aug indent_guide
    au!
    au ColorScheme * hi IndentGuidesOdd ctermbg=236
    au ColorScheme * hi IndentGuidesEven ctermbg=236
aug END
let g:vista_sidebar_width = 15
nnoremap <silent><Leader><Leader>o :Vista!!<CR>
let g:minimap_git_colors = 1
nnoremap <silent><Leader><Leader>m :MinimapToggle<CR>

" ### Writing
Plug 'SirVer/ultisnips'
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'lfilho/cosco.vim'
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
let g:UltiSnipsExpandTrigger="<C-s>"
" o -> A+CR (adhoc for snippet tabstop bug...)
nnoremap o A<CR>
let g:cosco_filetype_whitelist = ['cpp']
" return normal & save
inoremap jj <Esc>:CommaOrSemiColon<CR>:w<CR>
let g:move_key_modifier_visualmode = 'C'

" ### LSP IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'
Plug 'serna37/vim-IDE-menu'
let g:coc_global_extensions = ['coc-explorer', 'coc-snippets', 'coc-fzf-preview',
            \ 'coc-sh', 'coc-vimlsp', 'coc-json', 'coc-sql',
            \ 'coc-html', 'coc-css', 'coc-tsserver',
            \ 'coc-clangd', 'coc-go', 'coc-pyright', 'coc-java',
            \ ]
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'
au CursorHold * sil cal CocActionAsync('highlight')
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
nnoremap <Leader>d <Plug>(coc-definition)
nnoremap <silent><Leader>r :CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent><Leader>o :CocCommand fzf-preview.CocOutline<CR>
nnoremap <silent><Leader>? :cal CocAction('doHover')<CR>
nnoremap <Leader>, <plug>(coc-diagnostic-next)
nnoremap <Leader>. <plug>(coc-diagnostic-prev)
nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : comfortable_motion#flick(100)
nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : comfortable_motion#flick(-100)

" ### util
Plug 'serna37/vim-tutorial'
Plug 'soywod/unfog.vim'
Plug 'glidenote/memolist.vim'
Plug 'segeljakt/vim-silicon'
Plug 'nanotee/zoxide.vim'
Plug 'serna37/vim-atcoder-menu'

call plug#end()



" startify -------------------------------
let s:start = #{}

" ぼっちざろっく{{{
let s:start.btr_logo = [
    \'                                                                                                                                              dN',
    \'                                                                                                              ..                             JMF',
    \'                                                                                                         ..gMMMM%                           JMF',
    \'                                                                                                       .MM9^ .MF                           (MF',
    \'                                                                                              .(,      ("   .M#                  .g,      .MF',
    \'                                        .,  dN                                             gg,,M@          .M#                  .M#!      (M>',
    \'                                        JM} M#             .MNgg.                     .g,  ?M[ 7B         .MMg+gg,.           .MM"        ."',
    \'                                ...gNMN,.Mb MN           .gMM9!                      .(MN,  .=           .MMM9=  ?MN,         (WN,      .MM ',
    \'                   jN-      ..gMMN#!     (Mp(M}       .+MMYMF                    ..kMMWM%               ,M#^       dN.          .WNJ,   JM',
    \'                   MM     .MM9^  dN,                 dNB^ (M%                   ?M"!  ,M\        .,               .M#   .&MMMN,    ?"   M#',
    \'                   MN            .MN#^                    dM:  ..(J-,                 ,B         .TM             .M#   ,M@  .MF',
    \'                   MN.       ..MMBMN_                     dN_.MM@"!?MN.   TMm     .a,                           (M@         MM^',
    \'                   MN.     .MM"  JMb....       ..        dMMM=     .Mb            ?HNgJ..,                   .MM^',
    \'                   dM{          -MMM#7"T""   .dN#TMo       ?      .MM^                 ?!                 +gM#=',
    \'                   (M]         .MN(N#       .M@  .MF              .MM^                                      ~',
    \'                   .MN          ?"""             MM!            .MMD',
    \'                    ?N[                                         7"',
    \'                     TMe',
    \'                      ?MN,',
    \'                        TMNg,'
    \]
"}}}

let g:startify_custom_header = s:start.btr_logo


" onedark ---------------------------------
if !glob('~/.vim/plugged/onedark.vim')->empty()
    colorscheme onedark
endif

