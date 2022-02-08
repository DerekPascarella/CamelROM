# CamelROM
<img align="right" src="https://i.imgur.com/K3dXPTm.png">A perl module containing useful functions for those developing translation patches and other forms of ROM hacks.  Written by Derek Pascarella (ateam).

### decimal_to_hex
Subroutine to return hexadecimal representation of a decimal number.
- Parameter 1 - Decimal number.

### endian_swap
Subroutine to swap between big/little endian by reversing order of bytes from specified hexadecimal data.
- Parameter 1 - Hexadecimal representation of data.

### read_bytes
Subroutine to read a specified number of bytes (starting at the beginning) of a specified file, returning hexadecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read.

### read_bytes_at_offset
Subroutine to read a specified number of bytes, starting at a specific offset (in decimal format), of a specified file, returning hexadecimal representation of data.
- Parameter 1 - Full path of file to read.
- Parameter 2 - Number of bytes to read.
- Parameter 3 - Offset at which to read.

### write_bytes
Subroutine to write a sequence hexadecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexadecimal representation of data to be written to file.

### append_bytes
Subroutine to append a sequence hexadecimal values to a specified file.
- Parameter 1 - Full path of file to write.
- Parameter 2 - Hexadecimal representation of data to be written to file.

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
