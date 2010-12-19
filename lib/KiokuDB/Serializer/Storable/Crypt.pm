package KiokuDB::Serializer::Storable::Crypt;
use Moose;
use namespace::autoclean;

# ABSTRACT: encrypted Storable serializer

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

extends 'KiokuDB::Serializer::Storable';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;

1;
