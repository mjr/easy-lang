func int soma(int a, b; float c)

int a = 0

a = 1

a = a + a 

while (a < 10)
	a += 1
endwhile
endfunc 

func int merge(int arr; int left; int midle; int right)

int index_left, index_right, index_merged
int size_left = midle - left + 1 + 3
int size_right = right - midle

int left_array[size_left], right_array[size_right]

for( index_left = 0 ; index_left < size_left ; index_left++)
    right_array[index_right] = left_array[midle + 1 + index_right]
endfor


for(index_right = 0 ; index_right < size_right  ; index_right++ )
    right_array[index_right] = left_array[midle+1+ index_right]
    int a = 0
endfor

index_left = 0
index_merged = 0
index_merged = 0

while(index_left < size_left and index_right < size_right )
    
    if(left_array<= right_array)

    else
        left_array = 2
    endif

    index_merged++
endwhile



endfunc
