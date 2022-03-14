# CamelROM
# A perl module containing useful functions for those developing translation patches and other forms
# of ROM hacks.
#
# Written by Derek Pascarella (ateam)
package CamelROM;

# Declare module version.
our $VERSION = 0.2;

# Export subroutines.
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(decimal_to_hex endian_swap read_bytes read_bytes_at_offset write_bytes append_bytes insert_bytes patch_bytes generate_character_map_hash);

# Subroutine to return hexadecimal representation of a decimal number.
#
# 1st parameter - Decimal number.
sub decimal_to_hex
{
	return sprintf("%02X", $_[0]);
}

# Subroutine to swap between big/little endian by reversing order of bytes from specified hexadecimal
# data.
#
# 1st parameter - Hexadecimal representation of data.
sub endian_swap
{
	(my $hex_data = $_[0]) =~ s/\s+//g;
	my @hex_data_array = ($hex_data =~ m/../g);

	return join("", reverse(@hex_data_array));
}

# Subroutine to read a specified number of bytes (starting at the beginning) of a specified file,
# returning hexadecimal representation of data.
#
# 1st parameter - Full path of file to read.
# 2nd parameter - Number of bytes to read.
sub read_bytes
{
	my $file_to_read = $_[0];
	my $bytes_to_read = $_[1];

	open my $filehandle, '<:raw', "$file_to_read" or die $!;
	read $filehandle, my $bytes, $bytes_to_read;
	close $filehandle;
	
	return unpack 'H*', $bytes;
}

# Subroutine to read a specified number of bytes, starting at a specific offset (in decimal format), of
# a specified file, returning hexadecimal representation of data.
#
# 1st parameter - Full path of file to read.
# 2nd parameter - Number of bytes to read.
# 3rd parameter - Offset at which to read.
sub read_bytes_at_offset
{
	my $file_to_read = $_[0];
	my $bytes_to_read = $_[1];
	my $read_offset = $_[2];

	open my $filehandle, '<:raw', "$file_to_read" or die $!;
	seek $filehandle, $read_offset, 0;
	read $filehandle, my $bytes, $bytes_to_read;
	close $filehandle;
	
	return unpack 'H*', $bytes;
}

# Subroutine to write a sequence of hexadecimal values to a specified file.
#
# 1st parameter - Full path of file to write.
# 2nd parameter - Hexadecimal representation of data to be written to file.
sub write_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my @hex_data_array = split(//, $hex_data);

	open my $filehandle, '>', $output_file or die $!;
	binmode $filehandle;

	for(my $i = 0; $i < @hex_data_array; $i += 2)
	{
		my($high, $low) = @hex_data_array[$i, $i + 1];
		print $filehandle pack "H*", $high . $low;
	}

	close $filehandle;
}

# Subroutine to append a sequence of hexadecimal values to a specified file.
#
# 1st parameter - Full path of file to append.
# 2nd parameter - Hexadecimal representation of data to be appended to file.
sub append_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my @hex_data_array = split(//, $hex_data);

	open my $filehandle, '>>', $output_file or die $!;
	binmode $filehandle;

	for(my $i = 0; $i < @hex_data_array; $i += 2)
	{
		my($high, $low) = @hex_data_array[$i, $i + 1];
		print $filehandle pack "H*", $high . $low;
	}

	close $filehandle;
}

# Subroutine to insert a sequence of hexadecimal values at a specified offset (in decimal format) into a
# specified file.
#
# 1st parameter - Full path of file in which to insert data.
# 2nd parameter - Hexadecimal representation of data to be inserted.
# 3rd parameter - Offset at which to insert.
sub insert_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my $insert_offset = $_[2];
		
	my $data_before = &read_bytes($output_file, $insert_offset);
	my $data_after = &read_bytes_at_offset($output_file, (stat $output_file)[7] - $insert_offset, $insert_offset);
	
	&write_bytes($output_file, $data_before . $hex_data . $data_after);
}

# Subroutine to write a sequence of hexadecimal values at a specified offset (in decimal format) into a
# specified file, as to patch the existing data at that offset.
#
# 1st parameter - Full path of file in which to insert patch data.
# 2nd parameter - Hexadecimal representation of data to be inserted.
# 3rd parameter - Offset at which to patch.
sub patch_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my $insert_offset = $_[2];
	my $hex_data_length = length($hex_data) / 2;
	
	my $data_before = &read_bytes($output_file, $insert_offset);
	my $data_after = &read_bytes_at_offset($output_file, (stat $output_file)[7] - $insert_offset - $hex_data_length, $insert_offset + $hex_data_length);
	
	&write_bytes($output_file, $data_before . $hex_data . $data_after);
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
# The ASCII key in the returned hash will contain the custom hexadecimal value (e.g. $hash{'B'} will
# equal "01").
#
# 1st parameter - Full path of character map file.
sub generate_character_map_hash
{
	my $character_map_file = $_[0];
	my %character_table;

	open my $filehandle, '<', $character_map_file or die $!;
	chomp(my @mapped_characters = <$filehandle>);
	close $filehandle;

	foreach(@mapped_characters)
	{
		$character_table{(split /\|/, $_)[1]} = (split /\|/, $_)[0];
	}

	return %character_table;
}

# Obligatory "return true" statement.
1;
