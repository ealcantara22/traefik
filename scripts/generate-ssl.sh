#cd to current directory
cd $(dirname $0)

echo "\033[0;32mGenerating Certificate\033[0m"
openssl req \
  -newkey rsa:2048\
  -nodes \
  -keyout ./cert.key \
  -x509 \
  -days 365 \
  -config ../openssl.conf \
  -out ./cert.crt
