package KiokuDB::Serializer::YAML::Crypt;
use Moose;
use namespace::autoclean;

extends 'KiokuDB::Serializer::YAML';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;

1;
