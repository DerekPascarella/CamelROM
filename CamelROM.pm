# CamelROM
# A perl module containing useful functions for those developing translation patches and other forms of
# ROM hacks.
#
# Written by Derek Pascarella (ateam)
package CamelROM;

# Declare module version.
our $VERSION = 0.7;

# Export subroutines.
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(decimal_to_hex endian_swap read_bytes read_bytes_at_offset write_bytes append_bytes insert_bytes patch_bytes bytes_exist generate_character_map_hash);

# Subroutine to return hexadecimal representation of a decimal number.
#
# 1st parameter - Decimal number.
# 2nd parameter - Number of bytes with which to represent hexadecimal number (omit parameter for no
#                 padding).
sub decimal_to_hex
{
	if($_[1] eq "")
	{
		$_[1] = 0;
	}

	if($_[0] !~ /^-?\d+$/)
	{
		die "decimal_to_hex() failed: input is not a valid decimal number.\n";
	}

	return sprintf("%0" . $_[1] * 2 . "X", $_[0]);
}

# Subroutine to swap between big/little endian by reversing order of bytes from specified hexadecimal
# data.
#
# 1st parameter - Hexadecimal representation of data.
sub endian_swap
{
	(my $hex_data = $_[0]) =~ s/[^0-9A-Fa-f]//g;

	if(length($hex_data) % 2 != 0)
	{
		die "endian_swap() failed: input hex string must have an even number of characters.\n";
	}

	my @hex_data_array = ($hex_data =~ m/../g);

	return join("", reverse(@hex_data_array));
}

# Subroutine to read a specified number of bytes (starting at the beginning) of a specified file,
# returning hexadecimal representation of data.
#
# 1st parameter - Full path of file to read.
# 2nd parameter - Number of bytes to read (omit parameter to read entire file).
sub read_bytes
{
	my $input_file = $_[0];
	my $byte_count = $_[1];

	if($byte_count eq "")
	{
		$byte_count = (stat $input_file)[7];
	}

	open(my $filehandle, '<:raw', $input_file) or die "read_bytes() failed to open file '$input_file': $!";
	binmode($filehandle);

	my $bytes_read = read($filehandle, my $bytes, $byte_count);

	if(!defined($bytes_read))
	{
		die "read_bytes() failed to read from file '$input_file': $!";
	}
	elsif($bytes_read != $byte_count)
	{
		die "read_bytes() read only $bytes_read of $byte_count bytes from '$input_file'.";
	}

	close($filehandle);
	
	return(unpack 'H*', $bytes);
}

# Subroutine to read a specified number of bytes, starting at a specific offset (in decimal format), of
# a specified file, returning hexadecimal representation of data.
#
# 1st parameter - Full path of file to read.
# 2nd parameter - Number of bytes to read.
# 3rd parameter - Offset at which to read.
sub read_bytes_at_offset
{
	my $input_file = $_[0];
	my $byte_count = $_[1];
	my $read_offset = $_[2];

	my $file_size = (stat $input_file)[7];

	if($file_size < $read_offset + $byte_count)
	{
		die "read_bytes_at_offset() failed: offset ($read_offset) + length ($byte_count) exceeds file size ($file_size).\n";
	}

	open(my $filehandle, '<:raw', $input_file) or die "read_bytes_at_offset() failed to open file '$input_file': $!";
	binmode($filehandle);
	seek($filehandle, $read_offset, 0);

	my $bytes_read = read($filehandle, my $bytes, $byte_count);

	if(!defined($bytes_read))
	{
		die "read_bytes_at_offset() failed to read from '$input_file' at offset $read_offset: $!";
	}
	elsif($bytes_read != $byte_count)
	{
		die "read_bytes_at_offset() read only $bytes_read of $byte_count bytes from offset $read_offset.";
	}

	close($filehandle);

	return(unpack 'H*', $bytes);
}

# Subroutine to write a sequence of hexadecimal values to a specified file.
#
# 1st parameter - Full path of file to write.
# 2nd parameter - Hexadecimal representation of data to be written to file.
sub write_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;

	if(length($hex_data) % 2 != 0)
	{
		die "write_bytes() failed: hex string must have even length.\n";
	}

	open(my $filehandle, '>:raw', $output_file) or die "write_bytes() failed to open file '$output_file': $!";
	binmode($filehandle);

	for(my $i = 0; $i < length($hex_data); $i += 2)
	{
		print $filehandle pack("H*", substr($hex_data, $i, 2));
	}

	close($filehandle);
}

# Subroutine to append a sequence of hexadecimal values to a specified file.
#
# 1st parameter - Full path of file to append.
# 2nd parameter - Hexadecimal representation of data to be appended to file.
sub append_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;

	if(length($hex_data) % 2 != 0)
	{
		die "append_bytes() failed: hex string must have even length.\n";
	}

	open(my $filehandle, '>>', $output_file) or die "append_bytes() failed to open file '$output_file': $!";
	binmode($filehandle);

	for(my $i = 0; $i < length($hex_data); $i += 2)
	{
		print $filehandle pack("H*", substr($hex_data, $i, 2));
	}

	close($filehandle);
}

# Subroutine to insert a sequence of hexadecimal values at a specified offset (in decimal format) into
# a specified file, as to expand the existing file.
#
# 1st parameter - Full path of file in which to insert data.
# 2nd parameter - Hexadecimal representation of data to be inserted.
# 3rd parameter - Offset at which to insert.
sub insert_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my $insert_offset = $_[2];

	my $file_size = (stat $output_file)[7];

	if($file_size < $insert_offset)
	{
		die "insert_bytes() failed: offset is outside valid file size.\n";
	}

	open(my $filehandle, '<:raw', $output_file) or die "insert_bytes() failed to open file '$output_file' for reading: $!";
	binmode($filehandle);

	my $before_read = read($filehandle, my $data_before, $insert_offset);
	my $after_read = read($filehandle, my $data_after, $file_size - $insert_offset);

	if(!defined($before_read) || $before_read != $insert_offset)
	{
		die "insert_bytes() failed to read $insert_offset bytes before offset from '$output_file'.";
	}

	if(!defined($after_read) || $after_read != ($file_size - $insert_offset))
	{
		die "insert_bytes() failed to read remaining bytes after offset from '$output_file'.";
	}

	close($filehandle);

	my $combined_data = unpack("H*", $data_before) . $hex_data . unpack("H*", $data_after);

	&write_bytes($output_file, $combined_data);
}

# Subroutine to write a sequence of hexadecimal values at a specified offset (in decimal format) into
# a specified file, as to patch the existing data at that offset.
#
# 1st parameter - Full path of file in which to insert patch data.
# 2nd parameter - Hexadecimal representation of data to be inserted.
# 3rd parameter - Offset at which to patch.
sub patch_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my $patch_offset = $_[2];

	if(length($hex_data) % 2 != 0)
	{
		die "patch_bytes() failed: hex string must have even length.\n";
	}

	my $patch_byte_length = length($hex_data) / 2;
	my $file_size = (stat $output_file)[7];

	if($file_size < $patch_offset + $patch_byte_length)
	{
		die "patch_bytes() failed: patch range exceeds file size.\n";
	}

	open(my $filehandle, '+<:raw', $output_file) or die "patch_bytes() failed to open file '$output_file': $!";
	binmode($filehandle);
	seek($filehandle, $patch_offset, 0);

	for(my $i = 0; $i < length($hex_data); $i += 2)
	{
		print $filehandle pack("H*", substr($hex_data, $i, 2));
	}

	close($filehandle);
}

# Subroutine to return true if a specified byte pattern is found in a specified file.
#
# 1st parameter - Full path of file to read.
# 2nd parameter - Hexadecimal representation of data to be searched.
sub bytes_exist
{
	my $input_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;

	# Check validity
	die "bytes_exist() received invalid hex string" unless(length($hex_data) % 2 == 0);

	# Convert hex string to raw bytes
	my $target_bytes = pack('H*', $hex_data);

	open(my $filehandle, '<:raw', $input_file) or die "bytes_exist() failed to open file '$input_file': $!";

	my $buffer;
	my $chunk_size = 1024 * 1024;

	while(read($filehandle, $buffer, $chunk_size))
	{
		return 1 if(index($buffer, $target_bytes) != -1);
	}

	close($filehandle);

	return 0;
}


# Subroutine to generate hash mapping ASCII characters to custom hexadecimal values. Source character
# map file should be formatted with each character definition on its own line (<hex>|<ascii>). Example
# character map file:
#  ______
# |      |
# | 00|A |
# | 01|B |
# | 02|C |
# |______|
#
# The ASCII key in the returned hash will contain the custom hexadecimal value (e.g., $hash{'C'} will
# equal "02").
#
# 1st parameter - Full path of character map file.
sub generate_character_map_hash
{
	my $character_map_file = $_[0];
	my %character_table;

	open(my $filehandle, '<', $character_map_file) or die "generate_character_map_hash() failed to open file '$character_map_file': $!";
	chomp(my @mapped_characters = <$filehandle>);
	close($filehandle);

	foreach(@mapped_characters)
	{
		$_ =~ s/\P{IsPrint}//g;
		$_ =~ s/[^[:ascii:]]+//g;

		my @parts = split(/\|/, $_, 2);

		if(scalar(@parts) != 2)
		{
			die "generate_character_map_hash() encountered malformed line: '$_'\n";
		}

		my ($hex, $character) = @parts;
		$character_table{$character} = $hex;
	}

	return %character_table;
}

# Obligatory "return true" statement.
1;