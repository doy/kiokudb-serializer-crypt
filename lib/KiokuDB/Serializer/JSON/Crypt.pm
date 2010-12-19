package KiokuDB::Serializer::JSON::Crypt;
use Moose;
use namespace::autoclean;
# ABSTRACT: encrypted JSON serializer

=head1 SYNOPSIS

  use KiokuDB::Util;
  use KiokuDB::Serializer::JSON::Crypt;

  my $dsn    = '...';
  my $secret = '...';

  my $backend = KiokuDB::Util::dsn_to_backend(
      $dsn,
      serializer => KiokuDB::Serializer::JSON::Crypt->new(
          crypt_cipher => 'Rijndael',
          crypt_mode   => 'CFB',
          crypt_key    => $secret,
      ),
  )

  my $d = KiokuDB->new(backend => $backend);

=head1 DESCRIPTION

This serializer class extends L<KiokuDB::Serializer::JSON> to add encryption
support. See L<KiokuDB::Serializer::Crypt> for an explanation of the allowed
attributes.

=cut

extends 'KiokuDB::Serializer::JSON';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;

1;
