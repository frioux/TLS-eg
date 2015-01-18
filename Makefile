web.pem: class2CA.pem
	openssl genrsa -out web.key 4096
	openssl req \
   -new \
   -key web.key \
   -out web.csr \
   -subj /CN=localhost
	openssl ca \
   -keyfile class2CA.key \
   -cert class2CA.pem \
   -extensions usr_cert \
   -notext \
   -md sha256 \
   -in web.csr \
   -out web.pem \
   -batch \
   -config openssl.cnf
	cat web.pem class2CA.pem rootCA.pem > web.pem.new
	rm web.pem
	mv web.pem.new web.pem

class2CA.pem: rootCA.pem
	mkdir -p csr
	mkdir -p newcerts
	mkdir -p certs
	touch index.txt
	test -f serial || echo 1000 > serial
	openssl genrsa -out class2CA.key 4096
	openssl req \
   -new \
   -key class2CA.key \
   -out class2CA.csr \
   -subj "/CN=My Class 2 CA"
	openssl ca \
   -in class2CA.csr \
   -cert rootCA.pem \
   -keyfile rootCA.key \
   -extensions v3_ca \
   -out class2CA.pem \
   -notext \
   -md sha256 \
   -outdir newcerts \
   -batch \
   -config openssl.cnf

rootCA.pem:
	openssl genrsa -out rootCA.key 4096
	openssl req \
   -x509 \
   -new \
   -nodes \
   -key rootCA.key \
   -days 365 \
   -out rootCA.pem \
   -sha256 \
   -extensions v3_ca \
   -subj '/CN=My Root CA'

clean:
	rm -rf *.key *.pem *.csr serial serial.old index.txt index.txt.attr index.txt.old index.txt.attr.old newcrts certs csr
