const int MAXSIZE = 100;

func readMatrix(int matrix[MAXSIZE][MAXSIZE], int rows, int cols)
    print("Digite os elementos da matriz:\n");
    for (int i = 0; i < rows; i++)
        for (int j = 0; j < cols; j++)
            print("Elemento [%d][%d]: ", i, j);
            input(matrix[i][j]);
        endfor
    endfor
endfunc

func printMatrix(int matrix[MAXSIZE][MAXSIZE], int rows, int cols)
    print("Matriz:\n");
    for (int w = 0; w < rows; w++)
        for (int z = 0; z < cols; z++)
            print("%d ", matrix[w][z]);
        endfor
        print("\n");
    endfor
endfunc

func sumMatrices(int matrix1[MAXSIZE][MAXSIZE], int matrix2[MAXSIZE][MAXSIZE], int rows, int cols)
    int sumMatrix[MAXSIZE][MAXSIZE];
    for (int k = 0; k < rows; k++)
        for (int l = 0; l < cols; l++)
            sumMatrix[k][l] = matrix1[k][l] + matrix2[k][l];
        endfor
    endfor
    print("\nSoma das matrizes:\n");
    printMatrix(sumMatrix, rows, cols);
endfunc

func multiplyMatrices(int matrix1[MAXSIZE][MAXSIZE], int rows1, int cols1, int matrix2[MAXSIZE][MAXSIZE], int rows2, int cols2)
    if (cols1 != rows2)
        print("\nImpossível multiplicar as matrizes. O número de colunas da primeira matriz deve ser igual ao número de linhas da segunda matriz.\n");
        return;
    endif

    int productMatrix[MAXSIZE][MAXSIZE];
    for (int m = 0; m < rows1; m++)
        for (int n = 0; n < cols2; n++)
            productMatrix[m][n] = 0;
            for (int o = 0; o < cols1; o++)
                productMatrix[m][n] += matrix1[m][o] * matrix2[o][n];
            endfor
        endfor
    endfor
    print("\nProduto das matrizes:\n");
    printMatrix(productMatrix, rows1, cols2);
endfunc

main
    int rows1;
    int cols1;
    int rows2;
    int cols2;
    int matrix1[MAXSIZE][MAXSIZE];
    int matrix2[MAXSIZE][MAXSIZE];

    print("Informe o número de linhas e colunas da primeira matriz:\n");
    input(rows1);
    input(cols1);

    print("Informe o número de linhas e colunas da segunda matriz:\n");
    input(rows2);
    input(cols2);

    if (rows1 != rows2 or cols1 != cols2)
        print("\nAs matrizes não têm as mesmas dimensões. Impossível realizar a soma e o produto.\n");
        return;
    endif

    readMatrix(matrix1, rows1, cols1);
    readMatrix(matrix2, rows2, cols2);

    print("\nMatriz 1:\n");
    printMatrix(matrix1, rows1, cols1);

    print("\nMatriz 2:\n");
    printMatrix(matrix2, rows2, cols2);

    sumMatrices(matrix1, matrix2, rows1, cols1);
    multiplyMatrices(matrix1, rows1, cols1, matrix2, rows2, cols2);
endmain
