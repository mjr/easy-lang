func bool f(bool a, b, c)
    if (a)
        if (b)
            return true;
        else
            return c;
        endif
    endif
    return false;
endfunc

main
    if (f(true, false, true))
        print("f é verdadeiro");
    else
        print("f é falso");
    endif

    // int x = 2;
    // int y = 1;
    // int c = 4;
    // print(x ** 2 - y + c);

    float x = 0.2;
    float y = 0.1;
    int c = 1;
    int i = c;
    float xexp = x ** 2;
    float result = xexp - y + c;
    print(result);
endmain
