main
    int num = 0;
    int count1 = 0;
    int count2 = 0;
    int count3 = 0;
    int count4 = 0;

    print("Digite os números (encerre com um número negativo):\n");

    while (num >= 0)
        input(num);

        if (num < 0)
            print("Quantidade de números nos intervalos:\n");
            print("[0, 25]: %d\n", count1);
            print("[26, 50]: %d\n", count2);
            print("[51, 75]: %d\n", count3);
            print("[76, 100]: %d\n", count4);
            print("Numero negativo digitado. O programa será encerrado.");
            return 0;
        endif

        if (num >= 76 and num <= 100)
            count4++;
        endif

        if (num >= 51 and num <= 75)
            count3++;
        endif

        if (num >= 26 and num <= 50)
            count2++;
        endif

        if (num >= 0 and num <= 25)
            count1++;
        endif
    endwhile
endmain