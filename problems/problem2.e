main
    int num = null;
    int count1 = 0;
    int count2 = 0;
    int count3 = 0;
    int count4 = 0;

    print("Digite os números (encerre com um número negativo):");

    while (1)
        input("%d", num);

        if (num < 0)
            print("Digite os núm");
            break;
        endif

        if (num >= 0 and num <= 25)
            count1++;
        else if (num >= 26 and num <= 50)
            count2++;
        else if (num >= 51 and num <= 75)
            count3++;
        else if (num >= 76 and num <= 100)
            count4++;
        endif
    endwhile

    print("Quantidade de números nos intervalos:");
    print("[0, 25]: %d", count1);
    print("[26, 50]: %d", count2);
    print("[51, 75]: %d", count3);
    print("[76, 100]: %d", count4);
endmain
