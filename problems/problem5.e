//func mdc(int n, int m, int *r)
 //   if (n == 0) 
//        *r = m;
 //   else
//        if (m == 0) 
 //           *r = n;
//        else
//            if (n <= m)
//                mdc(n, m % n, r);
//            else
//                mdc(m, n % m, r);
//            endif
//        endif
//    endif
//endfunc

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

  //  if (n % m == 0)
   //     *r = m;
  //  endif

  //  if (m % n == 0)
   //     *r = n;
   // endif

    if (m > n)
        if (n != 0)
            mdc(n, m % n, r);
        else
            *r = n;
        endif
    endif

    if (m < n)
        if (m != 0)
            mdc(n % m, m, r);
        else
            *r = m;
        endif
    endif

   // if (n != 0 and m != 0 and *r == 0)
   //     *r = 1;
    //endif
endfunc

  //  if (m > n)
  //      return mdc(n, m % n);
  //  else
//        return mdc(m, n % m);

main
    int n;
    int m;
    int *r;

    print("Digite dois números naturais estritamente positivos: ");
    input(n);
    input(m);

    mdc(n, m, &r);

    printf("O maior divisor comum entre %d e %d é: %d\n", n, m, r);

endmain