package KiokuDB::Serializer::Crypt;
use Moose::Role;
use namespace::autoclean;

use Crypt::Util;

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

1;
