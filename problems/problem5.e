func mdc(int n, int m, int *r)
    if (n == 0)
        *r = m;
    endif

    if (m == 0)
        *r = n;
    endif

    if (n == m)
        *r = n;
    endif

    if (m > n)
        if (n != 0)
            mdc(n, m % n, r);
        else
            return 0;
        endif
    else
        if (m < n)
            if (m != 0)
                mdc(n % m, m, r);
            else
                return 0;
            endif
        endif
    endif
endfunc

main
    int n;
    int m;
    int r;

    print("Digite dois números naturais estritamente positivos: ");
    input(n);
    input(m);

    mdc(n, m, &r);

    printf("O maior divisor comum entre %d e %d é: %d\n", n, m, r);

endmain