siteId="$1"

case "$siteId" in
    (stitle) echo -n "www.supertitle.org" ;;
    (fiza) echo -n "www.fizasport.org" ;;
    (*) echo
    exit 1;;
esac
