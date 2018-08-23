" ==============================================  
" Functions  
" ============================================== 

" Platform
function! MySys()
  if has("win32")
    return "windows"
  else
    return "linux"
  endif
endfunction

function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc' 

" ==============================================  
" General settings  
" ==============================================  
set nocp  
set ru  
set nu  
"set cin  
"set cino = :0g0t0(sus  
set sm  
set ai  
set sw=4  
set ts=4  
set noet  
set lbr  
set hls  
"set backspace = indent , eol , start  
"set whichwrap = b , s , < , > , [ , ]  
"set fo+ = mB  
set selectmode =  
"set mousemodel = popup 
set keymodel =  
"set selection = inclusive  
"set matchpairs+ =  
"nmap <C-W><H> <C-L>
"nmap <C-W><L> <C-R>

" ==============================================  
" Cursor movement  
" ==============================================  
"nnoremap gj  
"nnoremap gk  
"vnoremap gj  
"vnoremap gk  
"inoremap gj  
"inoremap gk  
"nnoremap g$  
"nnoremap g0  
"vnoremap g$  
"vnoremap g0  
"inoremap g$  
"inoremap g0  
"nmap :confirm bd  
"vmap :confirm bd  
"omap :confirm bd  
"map! :confirm bd  
syntax on  
"set foldmethod=syntax  
if (has( " gui_running " ))  
set nowrap  
set guioptions+=b 
colo inkpot  
else  
set wrap  
"set color
colo torte 
endif  
"let mapleader = " , "  
if !has("gui_running")  
set t_Co=8  
set t_Sf=^[[3%p1%dm  
set t_Sb=^[[4%p1%dm  
endif  

""""""""""""""""""""""""""""""
" Tag list (ctags)
""""""""""""""""""""""""""""""
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1            
let Tlist_Exit_OnlyWindow = 1          
"let Tlist_Use_Right_Window = 1     
let Tlist_Use_Left_Window = 1
let Tlist_Sort_Type = 'name'
let Tlist_Show_Menu = 1
let Tlist_Auto_Open = 1
nmap <silent> <F8> :TlistToggle<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  endif
  set csverb
  set cscopequickfix=s-,c-,d-,i-,t-,e-
endif

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

""""""""""""""""""""""""""""""
" netrw setting
""""""""""""""""""""""""""""""
let g:netrw_winsize = 30
nmap <silent> <leader>fe :Sexplore!<cr> 
     
""""""""""""""""""""""""""""""
" BufExplorer
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 30  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
autocmd BufWinEnter \[Buf\ List\] setl nonumber 

""""""""""""""""""""""""""""""
" winManager setting
""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = "BufExplorer|FileExplorer"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <F7> :WMToggle<cr> 

""""""""""""""""""""""""""""""
" lookupfile setting
""""""""""""""""""""""""""""""
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
if filereadable("./filenametags")                "设置tag文件的名字
let g:LookupFile_TagExpr = '"./filenametags"'
endif

nmap <silent> <leader>lk :LUTags<cr>
nmap <silent> <leader>ll :LUBufs<cr>
nmap <silent> <leader>lw :LUWalk<cr>
nmap <silent> <F9> :Grep<CR>
nmap <silent> <F12> :A<CR>
nmap <silent> <F3> <C-]>

""""""""""""""""""""""""""""""
" omnicppcomplete setting
""""""""""""""""""""""""""""""
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType cpp set omnifunc=cppcomplete#Complete

set nocp
set completeopt=longest,menu 
filetype plugin on

let g:SuperTabRetainCompletionType=2  
let g:SuperTabDefaultCompletionType="<C-X><C-O>"


"colorscheme crt
colorscheme darkblue2
set autoindent
set smartindent

"第一行设置tab键为4个空格，第二行设置当行之间交错时使用4个空格

set tabstop=4
set shiftwidth=4
set showmatch
set ruler
set nohls
set incsearch

"代码折叠
"set foldenable
"set foldmethod=indent
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

"搜索高亮显示
set hlsearch

map <f2>   ::NERDTree<cr>
map <f3>   ::NERDTreeClose<cr>

" Ronny add Aug 27th, 2014
filetype on
syntax on
set ts=4
set tabstop=4
set shiftwidth=4
set history=1000
set background=dark
set expandtab
set autoindent
set nocompatible
set number
set smartindent
" set nobackup
set paste
let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1 
let Tlist_File_Fold_Auto_Close = 1
" let Tlist_Use_Right_Window = 1
" map %% as %:h
cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:h').'/' : '%%'

" enable Surround.vim
set nocompatible
filetype plugin on
runtime macros/matchit.vim

" cscope config from "https://blog.csdn.net/xysoul/article/details/47300663"
" cs find c|d|e|f|g|i|s|t name
" 0 或 s  查找这个 C 符号(可以跳过注释)
" 1 或 g  查找这个定义
" 2 或 d  查找这个函数调用的函数
" 3 或 c  查找调用过这个函数的函数
" 4 或 t  查找这个字符串
" 6 或 e  查找这个 egrep 模式
" 7 或 f  查找这个文件
" 8 或 i  查找包含这个文件的文件
" map <F4> :cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>
" imap <F4> <ESC>:cs add ./cscope.out .<CR><CR><CR> :cs reset<CR>

" add omnicomplete from https://blog.csdn.net/xysoul/article/details/47300663 
"-- omnicppcomplete setting --
" 按下F3自动补全代码，注意该映射语句后不能有其他字符，包括tab；否则按下F3会自动补全一些乱码
imap <F3> <C-X><C-O>
" 按下F2根据头文件内关键字补全
imap <F2> <C-X><C-I>
"set completeopt=menu,menuone " 关掉智能补全时的预览窗口
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype in popup window
let OmniCpp_GlobalScopeSearch=1 " enable the global scope search
let OmniCpp_DisplayMode=1 " Class scope completion mode: always show all members
"let OmniCpp_DefaultNamespaces=["std"]
let OmniCpp_ShowScopeInAbbr=1 " show scope in abbreviation and remove the last column
let OmniCpp_ShowAccess=1
" -- omnicomplete setting end --
set tags+=/opt/xiezhulin/include/c++/tags

" find current high-light selection content support '.' and '*'
" ref: skill 87 by Practical Vim
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Ronny add end
