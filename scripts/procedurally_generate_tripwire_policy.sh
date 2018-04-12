for S in `cat /etc/servers`; do
  for D in `ls /servers/$S`; do
    echo "/servers/$S/$D -> \$(ReadOnly) (recurse = true);">>~/twpol.txt
  done
done
