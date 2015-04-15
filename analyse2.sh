
match() {
  egrep "$1" "$2" >/dev/null && echo $3
}

cd ../linguist-tests/samples
find . -name '*.fs' | while read i; do
  echo -n "$i: "
  if match '^(: |new-device)' "$i" Forth; then :
  elif match '^(#include|#pragma|void|uniform|varying|precision)' "$i" GLSL; then :
  elif match '^('$'\xEF'$'\xBB'$'\xBF''|import|let|#light|module|namespace|open|type)' "$i" 'F#'; then :
  else echo unknown
  fi
done
