siteId="$1"

case "$siteId" in
    (stitle) echo -n "supertitle" ;;
    (fiza) echo -n "fizasport" ;;
    (*) echo
    exit 1;;
esac
