for S in `ls /servers`; do
  echo "( rulename = "$S", severity = 100)">>~/twpol.txt
  echo "{">>~/twpol.txt
  for D in `ls /servers/$S | grep -v dev | grep -v srv | grep -v proc`; do
    echo "/servers/$S/$D -> \$(ReadOnly) (recurse = true);">>~/twpol.txt
  done
  echo "}">>~/twpol.txt
done
