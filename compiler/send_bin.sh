# arg 1 : file to write
# arg 2 : device to write on (usually ttyUSB1)

if [ ! -e $2 ]; then
  echo "Périphérique $2 non connecté"
  exit 1
fi

cat $1 > $2
