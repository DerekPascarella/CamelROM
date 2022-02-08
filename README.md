# CamelROM
A perl module containing useful functions for those developing translation patches and other forms of ROM hacks.  Written by Derek Pascarella (ateam).

### decimal_to_hex
Subroutine to return hexidecimal representation of a decimal number.
- Parameter 1 - Decimal number.

### endian_swap
Subroutine to swap between big/little endian by reversing order of bytes from specified hexidecimal data.
- Parameter 1 - Hexidecimal representation of data.

### read_bytes
Subroutine to read a specified number of bytes (starting at the beginning) of a specified file, returning hexidecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read.

### read_bytes_at_offset
Subroutine to read a specified number of bytes, starting at a specific offset (in decimal format), of a specified file, returning hexidecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read.
- Parameter 3 - Offset at which to read.

### write_bytes
Subroutine to write a sequence hexidecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexidecimal representation of data to be written to file.

### append_bytes
Subroutine to append a sequence hexidecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexidecimal representation of data to be written to file.

### generate_character_map_hash
Subroutine to generate hash mapping ASCII characters to custom hexidecimal values. Source character map file should be formatted with each character definition on its own line (\<hex\>|\<ascii\>). Example character map file:
``` 
  ______
 |      |
 | 00|A |
 | 01|B |
 | 02|C |
 |______|
```

The ASCII key in the returned hash will contain the custom hexidecimal value (e.g. $hash{'B'} will equal "01").
- Parameter 1 - Full path of character map file.
