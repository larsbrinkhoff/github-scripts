
match() {
  egrep "$1" "$2" >/dev/null && echo -n " $3"
}

TYPE=rs

cd ../linguist-tests/samples-$TYPE
find . -type f -name "*.$TYPE" | while read i; do
  echo -n $i:
  case "$i" in
  */rs/*) echo " RenderScript" ;; 
  *RenderScript*) echo " RenderScript" ;;
  */build/classes/*) echo " javac?" ;;
  */WEB-INF/classes/*) echo " javac?" ;;
  *ResPack*) echo " ResPack" ;;
  */Paxa/postbird/*) echo " RedScript" ;;
  *)
    match '^(use |fn |mod |pub |impl|macro_rules! |auk!|#!?\[)' "$i" Rust
    match '(^(#pragma (rs|version)|#include|void|typedef))|__attribute__' "$i" RenderScript
    match '(^require |do *\|)' "$i" RedScript
    echo "" ;;
  esac
done

: <<EOF
 Actual			After	Before
    707  RenderScript	745
    225  Rust		250	995
     45  javac?
     12  unknown	  5	  5
      7  RedScript
      4  ResPack
EOF

: <<EOF
 Actual			After	Before
    998  RenderScript	1000
      2  C
	 unknown		1000
EOF
