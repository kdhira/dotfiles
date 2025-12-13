# Document Complex Aliases

## Problem
Several powerful aliases and functions in `zshrc.d/alias.sh` are undocumented:
- SSL/TLS utilities (`sslping`, `sslx509`, `x509`, `x509t`)
- RSA utilities (`rsamd5`, `x509md5`, `ssh-encrypt`, `ssh-decrypt`)
- Pasteboard operations (`pb`, `pbd`, `pbe`, `pc`, `pcd`, `pce`)

Without documentation, these are hard to remember and discover.

## Current State

**File:** `zshrc.d/alias.sh`

```bash
# Minimal comments, no usage documentation
alias ssh-encrypt='openssl pkeyutl -encrypt -inkey ~/.ssh/id_rsa'
alias ssh-decrypt='openssl pkeyutl -decrypt -inkey ~/.ssh/id_rsa'

rsamd5() {
    openssl rsa -noout -modulus $@ | openssl md5
}
```

## Proposed Solution

Add comprehensive header comments explaining each group of utilities:

```bash
###############################################################################
# SSL/TLS Certificate Utilities
###############################################################################

# sslping <host[:port]> - Connect to a server and display its certificate chain
#   Example: sslping google.com
#   Example: sslping api.example.com:8443
sslping() {
    ...
}

# sslx509 <host[:port]> - Display detailed certificate info for a server
#   Example: sslx509 github.com
sslx509() {
    ...
}

###############################################################################
# RSA/X.509 Verification Utilities
###############################################################################

# rsamd5 <key-file> - Get MD5 hash of RSA key modulus (for key matching)
#   Example: rsamd5 private.key
#   Use case: Verify a private key matches a certificate
rsamd5() {
    ...
}

# x509md5 <cert-file> - Get MD5 hash of certificate modulus
#   Example: x509md5 certificate.crt
#   Use case: Compare with rsamd5 output to verify key/cert match
x509md5() {
    ...
}
```

## Implementation Steps

1. Edit `zshrc.d/alias.sh`
2. Add section headers for each group of related commands
3. Add usage comments above each complex alias/function
4. Include examples for non-obvious usage

## Suggested Documentation Structure

```
###############################################################################
# General Aliases
###############################################################################
# ll, lll, b64

###############################################################################
# Pasteboard/Clipboard Utilities (macOS)
###############################################################################
# pb   - Paste from clipboard
# pbd  - Paste and base64 decode
# pbe  - Paste and base64 encode
# pc   - Copy to clipboard (pipe into)
# pcd  - Base64 decode and copy
# pce  - Base64 encode and copy

###############################################################################
# RSA Encryption (using SSH key)
###############################################################################
# ssh-encrypt - Encrypt stdin with ~/.ssh/id_rsa public key
# ssh-decrypt - Decrypt stdin with ~/.ssh/id_rsa private key

###############################################################################
# SSL/TLS Certificate Utilities
###############################################################################
# sslping  - Show certificate chain for remote server
# sslx509  - Show detailed cert info for remote server

###############################################################################
# Certificate/Key Verification
###############################################################################
# x509     - Alias for openssl x509
# x509t    - Alias for openssl x509 -text
# rsamd5   - MD5 of RSA key modulus (for matching)
# x509md5  - MD5 of cert modulus (for matching)
```

## Files to Modify

- `zshrc.d/alias.sh`

## Testing

1. Review documentation reads correctly
2. Verify `alias.sh` still sources without errors
3. Test documented examples work as described
