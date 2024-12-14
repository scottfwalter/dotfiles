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

my_array=(apple banana cherry)
#my_array=()
my_array+=(orange)

for item in $my_array; do
  echo $item
done

echo ${#my_array}

str="abc, def, ghi"
my_array=("${(f)$(cut -d',' -f1 filename.txt)}")
for item in $my_array; do
  echo $item
done

my_array=("${(f)$(echo $str | cut -d',' -f2)}")
for item in $my_array; do
  echo $item
done


local my_args=("$@")  # Create array from all parameters
echo $my_args

for item in $my_args; do
  echo $item
done
