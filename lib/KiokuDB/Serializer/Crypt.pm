package KiokuDB::Serializer::Crypt;
use Moose;
use namespace::autoclean;
# ABSTRACT: encrypt data stored in L<KiokuDB>

use Crypt::Util;
use KiokuDB::Backend::Hash;
use KiokuDB::Backend::Serialize;

=head1 SYNOPSIS

  use KiokuDB::Util;
  use KiokuDB::Serializer::Crypt;

  my $dsn    = '...';
  my $secret = '...';

  my $backend = KiokuDB::Util::dsn_to_backend(
      $dsn,
      serializer => KiokuDB::Serializer::Crypt->new(
          serializer   => 'json',
          crypt_cipher => 'Rijndael',
          crypt_mode   => 'CFB',
          crypt_key    => $secret,
      ),
  )

  my $d = KiokuDB->new(backend => $backend);

=head1 DESCRIPTION

This is a custom serializer for L<KiokuDB>, which wraps an existing serializer, encrypting the data before it is stored, and decrypting the data as it is retrieved. It can use several different encryption schemes (it's based on L<Crypt::Util>, so anything that that supports).

=cut

=attr crypt_key

The encryption key to use for encrypting and decrypting. Corresponds to
C<default_key> in L<Crypt::Util>.

=cut

has crypt_key => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        confess "The 'crypt_key' attribute for " . blessed($self)
              . " is required if the 'crypt' attribute is not given";
    },
);

=attr crypt_cipher

The encryption cipher to use. Corresponds to C<default_cipher> in
L<Crypt::Util>, and defaults to C<Rijndael>. You must ensure the appropriate
cipher backend is installed (by adding, for instance, L<Crypt::Rijndael> to the
dependency list for your application).

=cut

has crypt_cipher => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Rijndael',
);

=attr crypt_mode

The encryption mode to use. Corresponds to C<default_mode> in L<Crypt::Util>,
and defaults to C<CFB>. You must ensure the appropriate mode backend is
installed (by adding, for instance, L<Crypt::CFB> to the dependency list for
your application).

=cut

has crypt_mode => (
    is      => 'ro',
    isa     => 'Str',
    default => 'CFB',
);

=attr crypt

The L<Crypt::Util> object which will be used for the encryption. Typically,
this will be automatically created based on the other attribute values, but an
already-built object can be passed in here for more complicated usages.

=cut

has crypt => (
    is      => 'ro',
    isa     => 'Crypt::Util',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return Crypt::Util->new(
            disable_fallback => 1,
            default_cipher   => $self->crypt_cipher,
            default_mode     => $self->crypt_mode,
            default_key      => $self->crypt_key,
        );
    },
    handles => ['encrypt_string', 'decrypt_string'],
);

=attr serializer

The underlying serializer to use. KiokuDB will use this serializer to get a
string representation of the object which will then be encrypted. Defaults to
'storable'.

=cut

has serializer => (
    is      => 'ro',
    does    => 'KiokuDB::Backend::Serialize',
    coerce  => 1,
    default => 'storable',
    handles => 'KiokuDB::Backend::Serialize',
);

around serialize => sub {
    my $orig = shift;
    my $self = shift;
    my (@args) = @_;

    my $collapsed = $self->$orig(@args);
    return $self->encrypt_string($collapsed);
};

around deserialize => sub {
    my $orig = shift;
    my $self = shift;
    my ($collapsed, @args) = @_;

    return $self->$orig($self->decrypt_string($collapsed), @args);
};

with 'KiokuDB::Backend::Serialize';

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-kiokudb-serializer-crypt at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=KiokuDB-Serializer-Crypt>.

=head1 SEE ALSO

L<KiokuDB>

L<Crypt::Util>

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc KiokuDB::Serializer::Crypt

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/KiokuDB-Serializer-Crypt>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/KiokuDB-Serializer-Crypt>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=KiokuDB-Serializer-Crypt>

=item * Search CPAN

L<http://search.cpan.org/dist/KiokuDB-Serializer-Crypt>

=back

=cut

1;
