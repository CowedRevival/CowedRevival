/*

Title:           Trim White space
Credit to:       Metamorphman
Contributed by:  Metamorphman

This method of white space trimming uses text2ascii() to check the beginning, or ending characters in a string and
cut them off if necessary, thus trimming the whitespace off the string.

Method of use is simple, just pass a string as the
only argument in one of the following procs to have the corresponding whitespace cut off.

*/
proc/trimRight( text )
    var/x = 1
    for( x, x < length( text ), x++ )
        if( text2ascii( text, x ) == 32 )
            continue
        break
    return copytext( text, x )

proc/trimLeft( text )
    var/x = length( text )
    for( x, x > 1 , x-- )
        if( text2ascii( text, x ) == 32 )
            continue
        break
    return copytext( text, 1, x+1 )

proc/trimAll( text )
    return trimRight( trimLeft( text ) )