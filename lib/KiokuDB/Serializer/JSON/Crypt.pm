package KiokuDB::Serializer::JSON::Crypt;
use Moose;
use namespace::autoclean;

extends 'KiokuDB::Serializer::JSON';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;
no Moose;

1;
