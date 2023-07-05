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

func int endereco(int x1, int &x2, int x3)
    int var;
    &var = 2;
    var = &x2;
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

    if (2 > 3)
        print("f é verdadeiro");
    else
        print("f é falso");
    endif

    // int x = 2;
    // int y = 1;
    // int c = 4;
    // print(x ** 2 - y + c);

    bool isOk = f(true, true,true);

    float x = 0.2;
    float y = 0.1;
    int c = 1;
    int i = c;
    str text = "a";
    //c = 1 + "a";
    float xexp = x ** 2;
    float result = xexp - y + c;
    print(result);
    int vetor[5];
    vetor[0] = 2;
    vetor[i + c] = 6;
    int matriz[5][5];
    matriz[2][3] = 5;
    matriz[i + 1][c + 1] = 4;

    int varx;
    int address = endereco(c, &i, varx);
    int leitura;

    //leitura = read(int);

endmain
