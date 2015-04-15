
match() {
  egrep "$1" "$2" >/dev/null && echo -n " $3"
}

cd ../linguist-tests/samples-d
find . -name '*.d' | while read i; do
  echo -n $i:
  case "$i" in
  */*.o.d) echo " Makefile" ;;
  */*.cpio.d) echo " Makefile" ;;
  */EasySOA/*.d) echo " Makefile" ;;
  */*conf.d) echo " Configuration" ;;
  */err.*.d) echo " DTrace" ;;
  */tst.*.d) echo " DTrace" ;;
  */dtrace/*.d) echo " DTrace" ;;
  */momo/*.d) echo " DTrace" ;;
  */bin/ed/test/*) echo " Text" ;;
  */.hg/store/*) echo " Binary blob" ;;
  */displace.bin.d) echo " Binary blob" ;;
  *)
    match '^module ' "$i" D

    match '/.*:$' "$i" Makefile
    match '/.*: .* \\$' "$i" Makefile
    match '\.o: ' "$i" Makefile
    match ' : \\$' "$i" Makefile
    match '^ : ' "$i" Makefile
    match ': \\' "$i" Makefile

    match '^#!\s*/bin/(ba)?sh' "$i" Shell

    match '^#define ' "$i" C

    match 'exit\(0\);' "$i" DTrace
    match '^BEGIN' "$i" DTrace
    match '^provider ' "$i" DTrace
    match '^#pragma D option ' "$i" DTrace
    match '^#pragma D attributes ' "$i" DTrace
    match '^#pragma ident ' "$i" DTrace
    match '^#!/.*/dtrace' "$i" DTrace

    echo "" ;;
  esac
done

: <<EOF  Samples only:
    565  DTrace
    235  Makefile
    190  D
      6  Shell
      4  
EOF

: <<EOF
    635  DTrace
    225  Makefile
    111  D
      9  C
      9  Text
      6  Shell
      4  Binary blob
      1  Configuration
EOF

: <<EOF  Heuristics
    641  DTrace
    235  Makefile
    114  D
      6  Shell
      4  
EOF

: <<EOF  Before
    990  D
      6  Shell
      4  
EOF
