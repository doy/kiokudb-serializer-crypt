package KiokuDB::Serializer::YAML::Crypt;
use Moose;
use namespace::autoclean;

# ABSTRACT: encrypted YAML serializer

=head1 SYNOPSIS

  use KiokuDB::Util;
  use KiokuDB::Serializer::YAML::Crypt;

  my $dsn    = '...';
  my $secret = '...';

  my $backend = KiokuDB::Util::dsn_to_backend(
      $dsn,
      serializer => KiokuDB::Serializer::YAML::Crypt->new(
          crypt_cipher => 'Rijndael',
          crypt_mode   => 'CFB',
          crypt_key    => $secret,
      ),
  )

  my $d = KiokuDB->new(backend => $backend);

=head1 DESCRIPTION

This serializer class extends L<KiokuDB::Serializer::YAML> to add
encryption support. See L<KiokuDB::Serializer::Crypt> for an explanation of the
allowed attributes.

=cut

extends 'KiokuDB::Serializer::YAML';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;

1;
