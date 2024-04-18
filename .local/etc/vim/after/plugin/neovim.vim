if exists('g:loaded_neomake')
    autocmd! BufWritePost * Neomake

    " Use more appropriate standards when checking C/C++ syntax with neomake.
    let g:neomake_cpp_clang_args = neomake#makers#ft#c#clang()['args'] + ['-std=c99']
    let g:neomake_cpp_clang_args = neomake#makers#ft#cpp#clang()['args'] + ['-std=c++11']

    " haskellstack is insane.  https://github.com/neomake/neomake/issues/1259
    let g:neomake_haskell_enabled_makers = []

    let g:neomake_info_sign = {'text': '▐'}
    let g:neomake_error_sign = {'text': '▐'}
    let g:neomake_warning_sign = {'text': '▐'}
endif
