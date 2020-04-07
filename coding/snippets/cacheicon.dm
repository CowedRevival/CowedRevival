mob/proc/cache_icon(icon)
    if(src.client)
        src.client.Export("##action=load_rsc",icon)
client/proc/cache_icon(icon) src.Export("##action=load_rsc",icon)