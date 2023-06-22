func int factorial(int number)
    int result = 1;
    
    for (int i = 1; i <= number; i++)
        result *= i;
    endfor

    return result;
endfunc

func main()
    int n = input("Enter a positive integer: ");

    // Check if the number is positive
    if (n < 0)
        print("Error: Factorial is not defined for negative numbers.");
    else
        int fact = factorial(n);
        print("Factorial of {n} is {fact}.");
    endif

    int index_left, index_right, index_merged;

    index_left = 0;
    index_right = 0;
    index_merged = "test";
    if (index_left == 0 and index_right == 0)
        print("Igual");
    print(index_merged);
endfunc
