package KiokuDB::Serializer::Crypt;
use Moose::Role;
use namespace::autoclean;
# ABSTRACT: encrypt data stored in kiokudb

use Crypt::Util;

=head1 SYNOPSIS

  package My::Serializer;
  use Moose;
  with 'KiokuDB::Serializer', 'KiokuDB::Serializer::Crypt';

  sub serialize { ... }
  sub deserialize { ... }

=head1 DESCRIPTION

This is a role which wraps the C<serialize> and C<deserialize> methods of a
L<KiokuDB::Serializer> class, encrypting the results before storing them into
the database, and decrypting them when retrieving them. It can use several
different encryption schemes (it's based on L<Crypt::Util>, so anything that
that supports).

Unless you are writing a custom serializer, you probably want to look at the
classes which consume this role: L<KiokuDB::Serializer::JSON::Crypt>,
L<KiokuDB::Serializer::YAML::Crypt>, and
L<KiokuDB::Serializer::Storable::Crypt>.

=cut

=attr crypt_key

The encryption key to use for encrypting and decrypting. Corresponds to
C<default_key> in L<Crypt::Util>.

=cut

has crypt_key => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

=attr crypt_cipher

The encryption cipher to use. Corresponds to C<default_cipher> in
L<Crypt::Util>, and defaults to C<Rijndael>. You must ensure the appropriate
cipher backend is installed (by adding, for instance, L<Crypt::Rijndael> to the
dependency list for your application).

=cut

has crypt_cipher => (
    is       => 'ro',
    isa      => 'Str',
    default  => 'Rijndael',
);

=attr crypt_mode

The encryption mode to use. Corresponds to C<default_mode> in L<Crypt::Util>,
and defaults to C<CFB>. You must ensure the appropriate mode backend is
installed (by adding, for instance, L<Crypt::CFB> to the dependency list for
your application).

=cut

has crypt_mode => (
    is       => 'ro',
    isa      => 'Str',
    default  => 'CFB',
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
