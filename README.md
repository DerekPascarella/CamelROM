# CamelROM
<img align="right" src="https://i.imgur.com/K3dXPTm.png">A Perl module containing useful functions for those developing translation patches and other forms of ROM hacks.

CamelRom is currently at version 0.5.

### decimal_to_hex
Subroutine to return hexadecimal representation of a decimal number.
- Parameter 1 - Decimal number.
- Parameter 2 - Number of bytes with which to represent hexadecimal number (omit parameter for no padding).

Example usage:
```
my $decimal = "10";                      # defining variable with decimal value
my $hex = decimal_to_hex($decimal, 2);   # subroutine returns hexadecimal representation
print $hex;                              # prints "000A"
$hex = decimal_to_hex($decimal, 1);      # subroutine returns hexadecimal representation
print $hex;                              # prints "0A"
$hex = decimal_to_hex($decimal);         # subroutine returns hexadecimal representation
print $hex;                              # prints "A"
$decimal = "256";                        # defining variable with decimal value
$hex = decimal_to_hex($decimal, 3);      # subroutine returns hexadecimal representation
print $hex;                              # prints "000100"
$hex = decimal_to_hex($decimal, 2);      # subroutine returns hexadecimal representation
print $hex;                              # prints "0100"
$hex = decimal_to_hex($decimal);         # subroutine returns hexadecimal representation
print $hex;                              # prints "100"
```

### endian_swap
Subroutine to swap between big/little endian by reversing order of bytes from specified hexadecimal data.
- Parameter 1 - Hexadecimal representation of data.

Example usage:
```
my $bytes_be = "01 02 03 04";            # byte string can have spaces (or not)
my $bytes_le = endian_swap($bytes_be);   # subroutine returns reversed byte string
print $bytes_le;                         # prints "04030201"
```

### read_bytes
Subroutine to read a specified number of bytes (starting at the beginning) of a specified file, returning hexadecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read (omit parameter to read entire file).

Example usage:
```
my $bytes = read_bytes("file.bin", 4);   # reads first 4 bytes of "file.bin"
print $bytes;                            # prints first 4 bytes (e.g., "8263826F")
```

### read_bytes_at_offset
Subroutine to read a specified number of bytes, starting at a specific offset (in decimal format), of a specified file, returning hexadecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read.
- Parameter 3 - Offset at which to read.

Example usage:
```
my $bytes = read_bytes_at_offset("file.bin", 4, 16);   # reads first 4 bytes of "file.bin" after decimal offset 16
print $bytes;                                          # prints first 4 bytes after decimal offset 16 (e.g., "826F826B")
```

### write_bytes
Subroutine to write a sequence of hexadecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexadecimal representation of data to be written to file.

Example usage:
```
my $bytes = "01 02 03 04";        # byte string can have spaces (or not)
write_bytes("out.bin", $bytes);   # writes new (or overwrites existing) file with the 4 bytes "01020304"
```

### append_bytes
Subroutine to append a sequence of hexadecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexadecimal representation of data to be written to file.

Example usage:
```
my $bytes = "05 06 07 08";         # byte string can have spaces (or not)
append_bytes("out.bin", $bytes);   # appends existing file with the 4 bytes "05060708"
```

### insert_bytes
Subroutine to insert a sequence of hexadecimal values at a specified offset (in decimal format) into a specified file, as to expand the existing file.
- Parameter 1 - Full path of file in which to insert data.
- Parameter 2 - Hexadecimal representation of data to be inserted.
- Parameter 3 - Offset at which to insert.

Example usage:
```
my $bytes = "05 06 07 08";            # byte string can have spaces (or not)
insert_bytes("out.bin", $bytes, 4);   # inserts "05 06 07 08" into file at decimal offset 4
```

### patch_bytes
Subroutine to write a sequence of hexadecimal values at a specified offset (in decimal format) into a specified file, as to patch the existing data at that offset.
- Parameter 1 - Full path of file in which to insert patch data.
- Parameter 2 - Hexadecimal representation of data to be inserted.
- Parameter 3 - Offset at which to patch.

Example usage:
```
my $bytes = "05 06 07 08";            # byte string can have spaces (or not)
patch_bytes("out.bin", $bytes, 4);    # patches file's data at decimal offset 4 with "05060708"
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

The ASCII key in the returned hash will contain the custom hexadecimal value (e.g., $hash{'B'} will equal "01").
- Parameter 1 - Full path of character map file.

Example usage:
```
my %character_map = generate_character_map_hash("table.txt");   # creates hash with key-value pairs for defined characters in "table.txt"
print $character_map{'C'};                                      # prints hexadecimal representation of "A" (e.g., "02") according to "table.txt"
```
