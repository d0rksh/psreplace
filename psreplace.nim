import urlly
import os
import strutils
proc concat_query(path:string,query:seq[(string,string)]):string=
    var build_url = path
    for index,data in query:
        if index == 0:
            build_url = build_url&"?"&query[index][0]&"="&query[index][1]
        else:
            build_url = build_url&"&"&query[index][0]&"="&query[index][1]
    return build_url
proc process_path(path:seq[string],payload:string,query:seq[(string,string)],sc:string,host:string):void=
    for index in 1..path.len()-1:
        if index == 1:
            var current = encodeUrlComponent(payload)
            var next_data = path[2..path.len()-1]
            var qu = current&"/"&next_data.join("/")
            echo sc&"://"&host&"/"&concat_query(qu,query)
        else:
            var front = path[1..index-1]
            var back =  path[index+1..path.len()-1]
            if index == path.len()-1:
                 echo sc&"://"&host&"/"&concat_query(front.join("/")&"/"&encodeUrlComponent(payload),query)
            else:
                echo sc&"://"&host&"/"&concat_query(front.join("/")&"/"&encodeUrlComponent(payload)&"/"&back.join("/"),query)
var input = readAll(stdin)
var all_url = split(input,"\n")
for url in all_url:
     var purl = parseUrl(url)
     var splited = purl.path().split("/")
     var payload = "FUZZ"
     if paramCount() >= 1:
         payload = paramStr(1)
     process_path(splited,payload,purl.query,purl.scheme,purl.hostname)
     
# testing     
     
