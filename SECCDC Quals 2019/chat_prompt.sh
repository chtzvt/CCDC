echo "Username?"
read uname

while true; do
clear
echo "Message:"
read msg
echo "[$uname@`date +%H:%M`]: $msg" >>~/Desktop/CCDC/chat.txt
done
