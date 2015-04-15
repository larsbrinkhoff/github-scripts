
match() {
  egrep "$1" "$2" >/dev/null && echo -n " $3"
}

cd ../linguist-tests/samples-fr
find . -name '*.fr' | while read i; do
  echo -n $i:
  case "$i" in
  */Makefile*) echo " Makefile" ;;
  *.xml.fr) echo " XML" ;;
  *.html.fr) echo " HTML" ;;
  */menus.md.fr) echo " text" ;;
  */local_options.fr) echo " C" ;;
  */README.fr) echo " text" ;;
  */messages.fr) echo " text" ;;
  */*strings.fr) echo " text" ;;
  */PreludeBase.fr) echo " Frege" ;;
  */XSTEP.fr) echo " text" ;;
  */mixed*.fr) echo " Groff" ;;
  *)
    match '^(: |also |new-device|previous )' "$i" Forth
    match '^(import|module|package|data|type) ' "$i" Frege
    match '( (la|le|est) )|([Ff](rench|ran.*ais))' "$i" text
    echo "" ;;
  esac
done
