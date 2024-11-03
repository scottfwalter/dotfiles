#! /bin/zsh

stocks=()

function fun1(){
  stocks=(${stocks[@]} "banana")
}

fun1
fun1

echo "<?xml version=\"1.0\"?>"
echo "<items>"
for item in $stocks; do
  cat << EOF
  <item arg="abc" valid="yes">
    <title>$item</title>
	<subtitle>System</subtitle>
	<icon>abc</icon>
  </item>
EOF
done
echo "</items>"

