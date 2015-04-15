
match() {
  egrep "$1" "$2" >/dev/null && echo -n " $3"
}

cd ../linguist-tests/samples-fs
find . -name '*.fs' | while read i; do
  echo -n $i:
  case "$i" in
  */rs/*) echo " Filterscript" ;;
  *RenderScript*) echo " Filterscript" ;;
  *fsharp*) echo " F#" ;;
  *FSharp*) echo " F#" ;;
  *forth*) echo " Forth" ;;
  */ffl*) echo " Forth" ;;
  *sam-falvo/kestrel*) echo " Forth" ;;
  *)
    match '^(: |new-device)' "$i" Forth
    match '^ *(#light|import|let|module|namespace|open|type)' "$i" 'F#'
    match '^ *(#version|precision|uniform|varying)' "$i" GLSL
    match '#pragma rs|#include|__attribute__' "$i" Filterscript
    echo "" ;;
  esac
done

: <<EOF
 Actual			After	Before
    727  Filterscript	727
    127  F#		121	121
    110  Forth		120	120
     31  GLSL		 32	759
      1  Assembly
      5  unknown
EOF
