siteId="$1"

case "$siteId" in
    (abcd) echo -n "www.abcdhome.name" ;;
    (stitle) echo -n "www.supertitle.org" ;;
    (fiza) echo -n "www.fizasport.com" ;;
    (guppy) echo -n "www.superguppy.io" ;;
    (*) echo
    exit 1;;
esac
