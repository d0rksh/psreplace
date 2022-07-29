# psreplace

Takes Lists of URL's from stdin and replaces all path with given payload


# Nim installation
https://nim-lang.org/install_unix.html

# Build
```▶ nim c psreplace.nin```

# Usage & Output

Input file:

```
▶ cat urls.txt
https://web.archive.org/cdx/search/cdx?url=target.com&fl=original&collapse=url
```
Replace with given input:

```
▶ cat urls.txt | psreplace "' or sleep(1555)--#"
https://web.archive.org/%27+or+sleep%281555%29--%23/search/cdx?url=target.com&fl=original&collapse=url
https://web.archive.org/cdx/%27+or+sleep%281555%29--%23/cdx?url=target.com&fl=original&collapse=url
https://web.archive.org/cdx/search/%27+or+sleep%281555%29--%23?url=target.com&fl=original&collapse=url
```
