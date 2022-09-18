import urlly
import httpclient
import strutils
import sequtils
import threadpool
import terminal
import osproc
var thread_count = countProcessors() * 2
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
                 var url = sc&"://"&host&"/"&concat_query(front.join("/")&"/"&encodeUrlComponent(payload),query)
                 try:
                    var client = newHttpClient()
                    var resp = client.request(url)
                    var body =  resp.body()
                    if "pXSS" in body:
                        stdout.setForeGroundColor(fgRed)
                        stdout.styledWriteLine(fgDefault, url & " ", fgRed,styleBright, "[pXSS Reflected]",)
                        stdout.resetAttributes()
                 except:
                        discard


            else:
                var url =  sc&"://"&host&"/"&concat_query(front.join("/")&"/"&encodeUrlComponent(payload)&"/"&back.join("/"),query)
                try:
                    var client = newHttpClient()
                    var resp = client.request(url)
                    var body = resp.body()
                    if "pXSS" in body:
                        stdout.setForeGroundColor(fgRed)
                        stdout.styledWriteLine(fgDefault, url & " ", fgRed,styleBright, "[pXSS Reflected]",styleBright )
                        stdout.resetAttributes()
                except:
                        discard
var input = readAll(stdin)
var all_url = split(input,"\n")
var sub_seq = all_url.distribute(thread_count)

proc starter_func(urls: seq[string]):void=
    for url in urls:
        var purl = parseUrl(url)
        var splited = purl.path().split("/")
        var payload = "pXSS"
        process_path(splited,payload,purl.query,purl.scheme,purl.hostname)

for url in sub_seq:
     spawn starter_func(url)
sync()
