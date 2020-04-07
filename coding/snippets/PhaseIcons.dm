genimage
    var
        icon/icon
        icon_state
        list/overlays[0]
        list/underlays[0]

        icon/genicon
    New(atom/A)
        icon=A.icon
        icon_state=A.icon_state
        for(var/X in A:overlays)
            var/genimage_layer/I=new
            I.icon=X:icon
            I.icon_state=X:icon_state
            overlays+=I
        for(var/X in A:underlays)
            var/genimage_layer/I=new
            I.icon=X:icon
            I.icon_state=X:icon_state
            underlays+=I
genimage_layer
    var
        icon
        icon_state
atom
    var
        genimage/fadeimage1
        genimage/fadeimage2
        icon/fadeinicon
        icon/fadeouticon
    proc
        anim_fadein(icon=initial(src.icon),icon_state=initial(src.icon_state), \
density=initial(src.density),opacity=initial(src.opacity))
            if(!icon) return
            src.icon=icon  //these two are here for genicons() to do its work.
            src.icon_state=icon_state
            genicons()
            src.density=density
            src.icon=fadeinicon
            flick("",src)
            sleep(8)
            src.opacity=opacity
            src.icon=icon
            src.icon_state=icon_state
        anim_fadeout(density=initial(src.density),opacity=initial(src.opacity))
            genicons()
            src.opacity=opacity
            icon=fadeouticon
            flick("",src)
            sleep(8)
            src.density=density
            icon=null
        genicons(override=0)
            .=0
            if(!fadeimage1||!genicons_check(fadeimage1)||override)
                .=1
                fadeimage1=new(src)
                fadeimage1.genicon=new('Icons/blank.dmi')
                for(var/genimage_layer/I in fadeimage1.underlays)
                    fadeimage1.genicon.Blend(icon(I.icon,I.icon_state),\
ICON_OVERLAY)
                fadeimage1.genicon.Blend(icon(fadeimage1.icon,\
fadeimage1.icon_state),ICON_OVERLAY)
                for(var/genimage_layer/I in fadeimage1.overlays)
                    fadeimage1.genicon.Blend(icon(I.icon,I.icon_state),\
ICON_OVERLAY)
                for(var/i=2,i<=32,i+=2)
                    fadeimage1.genicon.DrawBox(null,i,1,i,31) //create dither effect
            if(!fadeimage2||!genicons_check(fadeimage2)||override)
                .=1
                fadeimage2=new(src)
                fadeimage2.genicon=new('Icons/blank.dmi')
                for(var/genimage_layer/I in fadeimage2.underlays)
                    fadeimage2.genicon.Blend(icon(I.icon,I.icon_state),ICON_OVERLAY)
                fadeimage2.genicon.Blend(icon(fadeimage2.icon,fadeimage2.icon_state),\
ICON_OVERLAY)
                for(var/genimage_layer/I in fadeimage2.overlays)
                    fadeimage2.genicon.Blend(icon(I.icon,I.icon_state),ICON_OVERLAY)
                for(var/i=2,i<=32,i+=2)
                    fadeimage2.genicon.DrawBox(null,i,1,i,31) //create dither effect
                for(var/i=2,i<=32,i+=2)
                    fadeimage2.genicon.DrawBox(null,1,i,31,i) //create second dither effect
            if(.)
                fadeinicon=new('Icons/blank.dmi',icon_state="")
                fadeinicon.Insert(fadeimage2.genicon,icon_state="",delay=2,\
frame=2)
                fadeinicon.Insert(fadeimage1.genicon,icon_state="",delay=2,\
frame=3)
                fadeinicon.Insert(icon(icon,icon_state),icon_state="",delay=2,\
frame=4)

                fadeouticon=new(icon(icon,icon_state),icon_state="")
                fadeouticon.Insert(fadeimage1.genicon,icon_state="",delay=2,\
frame=2)
                fadeouticon.Insert(fadeimage2.genicon,icon_state="",delay=2,\
frame=3)
                fadeouticon.Insert('Icons/blank.dmi',icon_state="",delay=2,\
frame=4)
            for(var/client/C)
                C.cache_icon(fadeinicon)
                C.cache_icon(fadeouticon)
        genicons_check(genimage/I)
            if(I.icon!=src.icon||I.icon_state!=src.icon_state) return 1
            .=0
            var/list
                overlays[0]
                underlays[0]
            for(var/X in src.overlays)
                var/genimage_layer/L
                for(L in I.overlays)
                    if(L.icon==X:icon&&L.icon_state==X:icon_state) break
                if(L) overlays+=L
                else {.=1;break;}
            if(.) return 1
            for(var/X in src.underlays)
                var/genimage_layer/L
                for(L in I.underlays)
                    if(L.icon==X:icon&&L.icon_state==X:icon_state) break
                if(L) underlays+=L
                else {.=1;break;}
            if(.) return 1
            for(var/genimage_layer/X in src.overlays) if(!(X in overlays))
                return 1
            for(var/genimage_layer/X in src.underlays) if(!(X in underlays))
                return 1