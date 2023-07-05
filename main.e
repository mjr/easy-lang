func bool f(bool a, bool b, bool c)
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
    // if (1 == 1)
    //     print("f é verdadeiro");
    // else
    //     print("f é falso");
    // endif

    // print("middle");

    // if (0 == 1)
    //     print("f é verdadeiro");
    // else
    //     print("f é falso");
    // endif

    // print("final");
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
    c = 2;
    float xexp = x ** 2;
    float result = xexp - y + c;
    print(result);
    int vetor[5];
    vetor[0] = 2;
    vetor[i + c] = 6;
endmain
