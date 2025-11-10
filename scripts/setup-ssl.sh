#!/bin/bash
# Setup SSL certificates for nginx
# This script generates self-signed certificates for development
# For production, replace with certificates from a trusted CA (Let's Encrypt, etc.)

set -e

SSL_DIR="ssl"
CERT_FILE="$SSL_DIR/cert.pem"
KEY_FILE="$SSL_DIR/key.pem"

echo "BP Prediction Tool - SSL Certificate Setup"
echo "=========================================="
echo ""

# Check if certificates already exist
if [ -d "$SSL_DIR" ] && [ -f "$CERT_FILE" ] && [ -f "$KEY_FILE" ]; then
    echo "SSL certificates already exist in $SSL_DIR/"
    echo "To regenerate, delete the $SSL_DIR directory and run this script again."
    exit 0
fi

# Create SSL directory
echo "Creating SSL directory..."
mkdir -p "$SSL_DIR"

# Generate self-signed certificate
echo "Generating self-signed SSL certificate..."
echo "(Valid for 365 days)"
echo ""

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$KEY_FILE" \
    -out "$CERT_FILE" \
    -subj "/C=US/ST=State/L=City/O=BPPrediction/CN=localhost" \
    2>/dev/null

# Set proper permissions
chmod 600 "$KEY_FILE"
chmod 644 "$CERT_FILE"

echo ""
echo "✓ SSL certificates generated successfully!"
echo ""
echo "Certificate: $CERT_FILE"
echo "Private key: $KEY_FILE"
echo ""
echo "⚠️  IMPORTANT NOTES:"
echo "   - These are self-signed certificates for DEVELOPMENT ONLY"
echo "   - Browsers will show security warnings"
echo "   - For PRODUCTION, use certificates from a trusted CA:"
echo "     * Let's Encrypt (free): https://letsencrypt.org/"
echo "     * Certbot: https://certbot.eff.org/"
echo ""
echo "Production SSL Setup:"
echo "  1. Install certbot: sudo apt-get install certbot"
echo "  2. Generate certificate: sudo certbot certonly --standalone -d yourdomain.com"
echo "  3. Copy to ssl/: sudo cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ssl/cert.pem"
echo "  4. Copy key: sudo cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ssl/key.pem"
echo ""
