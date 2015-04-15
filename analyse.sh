foreach() {
  for i in ../linguist-tests/samples/*; do
    egrep -r "$1" $i >/dev/null && echo $i
  done
}


foreach '^(: |new-device)' > samples-fs.forth
foreach '^(#include|void|uniform|varying|precision)' > samples-fs.shader
foreach '^('$'\xEF'$'\xBB'$'\xBF''|import|module|let|open|namespace)' > samples-fs.fsharp

# ../linguist-tests/samples/wuxy		text
# ../linguist-tests/samples/tombensve		config
# ../linguist-tests/samples/solb		asm
# ../linguist-tests/samples/sam-falvo		forth
# ../linguist-tests/samples/lightbits		shader
