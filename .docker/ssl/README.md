# Setup your SSL Certs.

## Generate private key
openssl genrsa -out ca.key 2048

## Generate CSR
openssl req -new -key ca.key -out ca.csr

## Generate Self Signed Key
openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt