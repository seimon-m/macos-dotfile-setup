function ywm --description 'Run yarn prod and upload with wordmove'
    if test "$argv"
        yp && wordmove push -t -e "$argv"
    else
        yp && wordmove push -t
    end
end
