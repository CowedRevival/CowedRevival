proc
    BubbleSort(list/L)
        .=L
        var/swapped = FALSE
        do
            swapped = FALSE
            for(var/i = 1 to (L.len-1))
                if(L[i] > L[i+1])
                    L.Swap(i,i+1)
                    swapped = TRUE
        while(swapped)