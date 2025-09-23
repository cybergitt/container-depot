#!/usr/bin/env bash
set -euo pipefail

CERT_DIR="./certs"
DAYS_VALID=1825

mkdir -p "$CERT_DIR"

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 domain1 [domain2 ... domainN]"
  exit 1
fi

DOMAINS=("$@")
PRIMARY_DOMAIN="${DOMAINS[0]}"

echo "🔑 Generating private key for $PRIMARY_DOMAIN..."
openssl genrsa -out "$CERT_DIR/$PRIMARY_DOMAIN.key" 2048

echo "📝 Creating OpenSSL config with SANs..."
SAN_CONFIG="$CERT_DIR/san.cnf"
{
  echo "[req]"
  echo "distinguished_name = req_distinguished_name"
  echo "req_extensions = v3_req"
  echo "[req_distinguished_name]"
  echo "[v3_req]"
  echo "subjectAltName = @alt_names"
  echo "[alt_names]"
  i=1
  for d in "${DOMAINS[@]}"; do
    echo "DNS.$i = $d"
    ((i++))
  done
} > "$SAN_CONFIG"

echo "📄 Generating CSR..."
openssl req -new -key "$CERT_DIR/$PRIMARY_DOMAIN.key" \
  -subj "/CN=$PRIMARY_DOMAIN" \
  -out "$CERT_DIR/$PRIMARY_DOMAIN.csr" \
  -config "$SAN_CONFIG"

echo "🔒 Generating self-signed certificate (valid ${DAYS_VALID} days)..."
openssl x509 -req -in "$CERT_DIR/$PRIMARY_DOMAIN.csr" \
  -signkey "$CERT_DIR/$PRIMARY_DOMAIN.key" \
  -days $DAYS_VALID \
  -extensions v3_req -extfile "$SAN_CONFIG" \
  -out "$CERT_DIR/$PRIMARY_DOMAIN.crt"

echo "🧹 Cleaning up CSR and config..."
rm -f "$CERT_DIR/$PRIMARY_DOMAIN.csr" "$SAN_CONFIG"

echo "✅ Done!"
echo "  Certificate: $CERT_DIR/$PRIMARY_DOMAIN.crt"
echo "  Private Key: $CERT_DIR/$PRIMARY_DOMAIN.key"
