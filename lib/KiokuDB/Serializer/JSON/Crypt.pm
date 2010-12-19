package KiokuDB::Serializer::JSON::Crypt;
use Moose;
use namespace::autoclean;
# ABSTRACT: encrypted JSON serializer

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

extends 'KiokuDB::Serializer::JSON';
with 'KiokuDB::Serializer::Crypt';

__PACKAGE__->meta->make_immutable;

1;
