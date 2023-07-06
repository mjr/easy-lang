func float pow(float base, int exponent)
    float result = 1.0;

    if (exponent >= 0)
        for (int i = 0; i < exponent; i++)
            result = result * base;
        endfor
    else
        for (int i = 0; i < -exponent; i++)
            result = result / base;
        endfor
    endif

    return result;
endfunc

main
    float x = 0.2;
    float y = 0.1;
    int c = 1;
    float xexp = pow(x, 2);
    float result = xexp - y + c;
    print(result);
endmain
