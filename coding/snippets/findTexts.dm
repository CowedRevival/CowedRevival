proc/findtextExs(haystack, list/needles, start=1, end=length(haystack))
    while(start <= end)
        for(var/needle in needles)
            var/i
            while(get_letter(haystack, start+i) == get_letter(needle, ++i))
                if(i >= length(needle))
                    return "[start];[needle]"
        start++

proc/get_letter(string, pos)
    return ascii2text(text2ascii(string,pos))