syntax on | set number laststatus=2 showtabline=2 incsearch hlsearch ignorecase smartcase shortmess-=S
let mapleader = "\<Space>"
" plugがない場合は以下を省略する(bash側で自動で入れるようにしているが念の為ガード)
if !glob('~/.vim')->empty()
" =====================================================================
call plug#begin()
" Enhanced vim motion
Plug 'serna37/vim-modern-basic'
Plug 'serna37/vim-anchor5'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-edgemotion'
Plug 'serna37/edgemotion-vertical'
Plug 'rhysd/clever-f.vim'
Plug 'unblevable/quick-scope'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/vim-asterisk'
Plug 'yuttie/comfortable-motion.vim'
Plug 'simeji/winresizer'

" Enhanced Visualization
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/goyo.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'tomasiser/vim-code-dark'

" Filer
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Explorer
Plug 'preservim/nerdtree'

" Reading
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'andymass/vim-matchup'
Plug 'preservim/vim-indent-guides'

" Writing
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'thinca/vim-partedit'

" TODO LSP系統全部消した

call plug#end()
" =====================================================================

" =====================================================================
" Enhanced vim motion
" =====================================================================
" easymotion/vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_keys='sfjkdawh'
let g:EasyMotion_smartcase = 1
let g:EasyMotion_disable_two_key_combo = 1
nnoremap s <Plug>(clever-f-reset)<Plug>(easymotion-s2)
nnoremap <Leader><Leader>s <Plug>(clever-f-reset)<Plug>(easymotion-sn)
nnoremap <Leader><Leader>w <Plug>(easymotion-overwin-w)

" haya14busa/vim-edgemotion
nnoremap <C-j> <Plug>(edgemotion-j)<Plug>(anchor)
nnoremap <C-k> <Plug>(edgemotion-k)<Plug>(anchor)

" rhysd/clever-f.vim
let g:clever_f_smart_case = 1
let g:clever_f_timeout_ms = 1500
let g:clever_f_highlight_timeout_ms = 1500
aug cleaver_f
    au!
    au ColorScheme * hi CleverFDefaultLabel cterm=BOLD,underline ctermfg=40 ctermbg=0
aug END

nnoremap <silent><leader>w <Plug>(clever-f-reset):QuickScopeToggle<CR>

" t9md/vim-quickhl
" haya14busa/vim-asterisk
nnoremap # <Plug>(asterisk-z*)<Plug>(quickhl-manual-this)
nnoremap <silent><Leader>q <Plug>(quickhl-manual-reset)<Plug>(clever-f-reset):noh<CR>

" yuttie/comfortable-motion.vim
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_interval = 1000.0 / 60
let g:comfortable_motion_friction = 70.0
let g:comfortable_motion_air_drag = 5.0
nnoremap <silent><C-f> :cal comfortable_motion#flick(200)<CR>
nnoremap <silent><C-b> :cal comfortable_motion#flick(-200)<CR>

" voldikss/vim-floaterm
set termwinkey=<C-e>
tnoremap <C-w> <Esc><BS>
tnoremap <C-x> <C-w><S-n>
tnoremap <silent><C-t> <C-\><C-n>:FloatermNew<CR>
tnoremap <silent><S-Tab> <C-\><C-n>:FloatermNext<CR>
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_width = 0.6
let g:floaterm_height = 1.2
let g:floaterm_position = 'bottomright'

" =====================================================================
" Enhanced Visualization
" =====================================================================
" vim-airline/vim-airline
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

" junegunn/goyo.vim
fu! s:goyo_enter()
    colorscheme codedark
    set number
endf

fu! s:goyo_leave()
    cal s:colorscheme_onedark()
endf

au! User GoyoEnter nested cal <SID>goyo_enter()
au! User GoyoLeave nested cal <SID>goyo_leave()
nnoremap <silent><Leader>z :Goyo<CR>

" machakann/vim-highlightedyank
let g:highlightedyank_highlight_duration = 300

" liuchengxu/vim-which-key
nnoremap <silent><Leader> :WhichKey '<Space>'<CR>
set timeoutlen=500

" =====================================================================
" Filer
" =====================================================================
" junegunn/fzf
" junegunn/fzf.vim
nnoremap <silent><Leader>f :<C-u>Files<CR>
nnoremap <silent><Leader>e :NERDTree<CR>
au QuickFixCmdPost *grep* cwindow
fu! s:grepCurrent() abort
    let word = input("[word]>>", expand('<cword>'))
    exe 'vimgrep /'.word.'/gj %'
endf
noremap <silent><Plug>(grep-current) :<C-u>cal <SID>grepCurrent()<CR>
nnoremap <silent><Leader>g <Plug>(grep-current)

" =====================================================================
" Reading
" =====================================================================
" junegunn/rainbow_parentheses.vim
au VimEnter * RainbowParentheses

" preservim/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'startify']
let g:indent_guides_auto_colors = 0
aug indent_guide
    au!
    au ColorScheme * hi IndentGuidesOdd ctermbg=236
    au ColorScheme * hi IndentGuidesEven ctermbg=234
aug END

" =====================================================================
" Writing
" =====================================================================
" matze/vim-move
let g:move_key_modifier_visualmode = 'C'

" jiangmiao/auto-pairs
let g:AutoPairsMapCh = 0

" 補完の選択
inoremap <expr><CR> pumvisible() ? '<C-y>' : '<CR>'
inoremap <expr><Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr><S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" =====================================================================
" Initiation, Art
" =====================================================================
" mhinz/vim-startify
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

" joshdick/onedark.vim
fu! s:del_col() abort
    aug onedark_comment
        au!
    aug END
endf
fu! s:colorscheme_onedark() abort
    if !glob('~/.vim/plugged/onedark.vim')->empty()
        aug onedark_comment
            au!
            " コメント色
            au ColorScheme * hi Comment term=bold ctermfg=245 guifg=#5C6370
            " 背景なし
            au ColorScheme * hi Normal ctermbg=none
            " 行番号
            au ColorScheme * hi LineNr ctermfg=245
            au ColorScheme * hi CursorLineNr ctermfg=245
            " カーソル
            au ColorScheme * hi CursorLine ctermbg=236
            au ColorScheme * hi CursorColumn ctermbg=236
            au ColorScheme * hi Visual ctermbg=240
        aug END
        colorscheme onedark
        cal timer_start(2000, { -> s:del_col() })
    endif
endf
cal s:colorscheme_onedark()

endif
