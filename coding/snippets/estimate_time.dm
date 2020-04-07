#define ESTTIME_BOUND 3


proc/estimate_time(num)
    num = abs(num)

    if(num >= 31536000000)
        //estimate in centuries
        var/amount = round(num/31536000000,1)
        return "[amount] centur[amount != 1 ? "ies" : "y"]"

    else if(num >= 3153600000)
        //estimate in decades
        var/amount = round(num/3153600000,1)
        return "[amount] decade[amount != 1 ? "s" : ""]"

    else if(num >= 315360000)
        //estimate in years
        var/amount = round(num/315360000,1)
        return "[amount] year[amount != 1 ? "s" : ""]"

    else if(num >= 25920000)
        //estimate in months
        var/amount = round(num/25920000,1)
        return "[amount] month[amount != 1 ? "s" : ""]"

    else if(num >= 6048000)
        //estimate in weeks
        var/amount = round(num/6048000,1)
        return "[amount] week[amount != 1 ? "s" : ""]"

    else if(num >= 864000)
        //estimate in days
        var/amount = round(num/864000,1)
        return "[amount] month[amount != 1 ? "s" : ""]"

    else if(num >= 36000)
        //estimate in hours
        var/amount = round(num/36000,1)
        return "[amount] hour[amount != 1 ? "s" : ""]"

    else if(num >= 600*ESTTIME_BOUND)
        //estimate in minutes
        var/amount = round(num/600,1)
        return "[amount] minute[amount != 1 ? "s" : ""]"

    else if(num >= 10)
        //estimate in seconds
        var/amount = round(num/10,1)
        return "[amount] second[amount != 1 ? "s" : ""]"

    else
        return "1 second"