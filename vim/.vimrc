" Automatically source vimrc on save.
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" Trim whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

set clipboard=unnamed
