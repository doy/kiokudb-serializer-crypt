package KiokuDB::Serializer::Crypt;
use Moose::Role;
use namespace::autoclean;
# ABSTRACT: encrypt data stored in kiokudb

use Crypt::Util;

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

has crypt_key => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has crypt_cipher => (
    is       => 'ro',
    isa      => 'Str',
    default  => 'Rijndael',
);

has crypt_mode => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'CFB',
);

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
