siteId="$1"

case "$siteId" in
    (abcd) echo -n "abcdhome" ;;
    (stitle) echo -n "supertitle" ;;
    (fiza) echo -n "fizasport" ;;
    (guppy) echo -n "superguppy" ;;
    (*) echo
    exit 1;;
esac
