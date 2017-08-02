function! Cmt()

python  << EOF

import os
import vim
import re
import datetime

try:
    #
    origin_line_buf = vim.current.buffer[:]
    del vim.current.buffer[:]

    for line in origin_line_buf:
        lstring_line = line
        lstring_line = lstring_line.lstrip()
        vim.current.buffer.append(line)
        if lstring_line.startswith('def'):
            white = '    ' # 4 white
            white_num , left = divmod(len(line)  - len(lstring_line) , 4)
            white = white * ( white_num  + 1)

            args_tuple = re.findall(r"\((.+?)\)", line)
            args_string = args_tuple[0] if args_tuple  else ''
            args = args_string.split(',') if args_string  else []
            vim.current.buffer.append('%s%s' % (white, '"""' ))
            vim.current.buffer.append('%s@Author: %s' % (white, os.getlogin()))
            vim.current.buffer.append('%s@Date: %s' % (white, str(datetime.datetime.today())))
            if args:
                host_prefix = 'http://127.0.0.1:8899'
                url_path = '?'
                args_subfix_tuple = ['{}='.format(arg).replace(' ','') for arg in args]
                args_subfix = ''.join(args_subfix_tuple)
                all_path = host_prefix + url_path + args_subfix 
                vim.current.buffer.append('%s@param url: %s' % (white, all_path))
            for arg in args:
                vim.current.buffer.append('%s@param %s:' % (white, arg))

            vim.current.buffer.append('%s%s' % (white, '"""' ))

except Exception as e:
    print e

EOF


endfunction

