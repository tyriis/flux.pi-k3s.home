.PHONY: help print-% certs fetch-sealed-secret-pem

# Show this help presented by https://github.com/Xanders/make-help
help:
	@cat $(MAKEFILE_LIST) | docker run --rm -i xanders/make-help

# print the content of a variable f.e. print-HOME
print-%:
	@echo '$*=$($*)'

# regenerate certificates as selaed secrets
certs:
	@echo "implement me!"

# fetches the sealed-secret public certificate and commit them to git
fetch-sealed-secret-pem:
	@kubeseal --fetch-cert --controller-name=sealed-secrets-controller --controller-namespace=secops > pub-sealed-secrets.pem
	@git add pub-sealed-secrets.pem
	@git commit pub-sealed-secrets.pem -m "New: pub-sealed-secrets.pem"
	@git push
