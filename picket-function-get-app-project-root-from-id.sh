appId="$1"

case "$appId" in
    (app0) echo -n "app0" ;;
    (books) echo -n "supertitlebooks" ;;
    (cv) echo -n "cv" ;;
    (fractals) echo -n "fractals" ;;
    (planets) echo -n "planets" ;;
    (*) echo
    exit 1;;
esac
