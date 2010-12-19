package KiokuDB::Serializer::Storable::Crypt;
use Moose;
use namespace::autoclean;

extends 'KiokuDB::Serializer::Storable';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;

1;
