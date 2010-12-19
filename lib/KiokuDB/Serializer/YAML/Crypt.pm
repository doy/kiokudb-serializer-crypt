package KiokuDB::Serializer::YAML::Crypt;
use Moose;
use namespace::autoclean;

# ABSTRACT: encrypted YAML serializer

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

extends 'KiokuDB::Serializer::YAML';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;

1;
