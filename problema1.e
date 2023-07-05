func float sum(float x, float y, int c)

return ( (x*x)-y ) + c;
endfunc

main

 // float x; nao funciona - pendente ajuste

    float x = 0.2;
    float y = 0.3;
    int c = 2;
    int result = sum(x,y,c);

    print("Resultado");
    print(result);
    
endmain