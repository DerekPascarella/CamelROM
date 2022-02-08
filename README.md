# CamelROM
<img align="right" src="https://i.imgur.com/K3dXPTm.png">A perl module containing useful functions for those developing translation patches and other forms of ROM hacks.  Written by Derek Pascarella (ateam).

### decimal_to_hex
Subroutine to return hexadecimal representation of a decimal number.
- Parameter 1 - Decimal number.

Example usage:
```
my $decimal = "10";                   # defining variable with decimal value
my $hex = decimal_to_hex($decimal);   # subroutine returns reversed hexadecimal representation
print "$hex";                         # prints "0A"
```

### endian_swap
Subroutine to swap between big/little endian by reversing order of bytes from specified hexadecimal data.
- Parameter 1 - Hexadecimal representation of data.

Example usage:
```
my $bytes_be = "01 02 03 04";            # byte string can have spaces (or not)
my $bytes_le = endian_swap($bytes_be);   # subroutine returns reversed byte string
print "$bytes_le";                       # prints "04 03 02 01"
```

### read_bytes
Subroutine to read a specified number of bytes (starting at the beginning) of a specified file, returning hexadecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read.

Example usage:
```
my $bytes = read_bytes("file.bin", 4);   # reads first 4 bytes of "file.bin"
print "$bytes";                          # prints first 4 bytes (e.g. "82 63 82 6F")
```

### read_bytes_at_offset
Subroutine to read a specified number of bytes, starting at a specific offset (in decimal format), of a specified file, returning hexadecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read.
- Parameter 3 - Offset at which to read.

Example usage:
```
my $bytes = read_bytes_at_offset("file.bin", 4, 16);   # reads first 4 bytes of "file.bin" after decimal offset 16
print "$bytes";                                        # prints first 4 bytes after decimal offset 16 (e.g. "82 6F 82 6B")
```

### write_bytes
Subroutine to write a sequence hexadecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexadecimal representation of data to be written to file.

Example usage:
```
my $bytes = "01 02 03 04";        # byte string can have spaces (or not)
write_bytes("out.bin", $bytes);   # writes new (or overwrites existing) file with the 4 bytes "01 02 03 04"
```

### append_bytes
Subroutine to append a sequence hexadecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexadecimal representation of data to be written to file.

Example usage:
```
my $bytes = "05 06 07 08";         # byte string can have spaces (or not)
append_bytes("out.bin", $bytes);   # writes new (or appends to existing) file with the 4 bytes "05 06 07 08"
```

### generate_character_map_hash
Subroutine to generate hash mapping ASCII characters to custom hexadecimal values. Source character map file should be formatted with each character definition on its own line (\<hex\>|\<ascii\>). Example character map file:
``` 
  ______
 |      |
 | 00|A |
 | 01|B |
 | 02|C |
 |______|
```

The ASCII key in the returned hash will contain the custom hexadecimal value (e.g. $hash{'B'} will equal "01").
- Parameter 1 - Full path of character map file.

Example usage:
```
my %character_map = generate_character_map_hash("table.txt");   # creates hash with key-value pairs for defined characters
print $character_map{'A'};                                      # prints hexadecimal representation of "A" (e.g. "8260")
```
