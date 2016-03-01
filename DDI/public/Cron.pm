#
# Parth::Cron - cron table class
#
# use Parth::Cron ;
#
# This package/class should probably have some additional members, such as
# members to reset the input file stream back to the beginning, explicitly
# closing the existing stream, etc.
#

package Parth::Cron ;
use re qw(taint) ;
use warnings FATAL => qw(all) ;
use strict ;
use English qw(-no_match_vars) ;
use Parth::CronEntry ;

#=============================================================================
# $cron = Parth::Cron->new('file' => $file) ;
# $cron = new Parth::Cron 'file' => $file ;
#
# Creates and returns a new Cron object that is associated with the file
# named $file. If the 'file' parameter is omitted, input is read from the
# STDIN. An exception is raised if the file cannot be opened.
#

sub new
{
  my $invocant = shift @ARG ;
  my $class = ref($invocant) || $invocant ;
  my %params = @ARG ;
  my $self = bless {}, $class ;

  # Open file if necessary
  if (exists $params{'file'})
  {
    $self->{'file'} = $params{'file'} ;
    open $self->{'handle'}, '<', $self->{'file'}
      or die "$self->{'file'}: $ERRNO\n" ;
  }
  else
  {
    $self->{'handle'} = \*STDIN ;
  }

  $self->{'file'} = exists $params{'file'} ? $params{'file'} : '-' ;
  return $self ;
}

#=============================================================================
# Close file when the object is destroyed. Probably not needed, but it can't
# hurt to let go of the resources.

sub DESTROY
{
  my $self = shift @ARG ;
  close $self->{'handle'}        if exists $self->{'file'} ;
}

#=============================================================================
# $entry = $cron->next() ;
#
# Returns a Parth::CronEntry object that represents the next job entry from the
# crontab object $cron.  Returns undef at end of file. Raises an exception if an
# error is detected.
#

sub next
{
  my $self = shift @ARG ;
  my $entry ;                # The cron entry object

  my $handle = $self->{'handle'} ;
  do
  {
    # Get next input line - exit loop at EOF
    my $input = <$handle> ;
    return undef unless defined $input ;

    chomp $input ;
    if ($input !~ m{^\s*#}        # Ignore comments
    &&  $input !~ m{^\s*$}        # Ignore blank lines
    &&  $input !~ m{^\s*\S+\s*=})    # Ignore environment settings
    {
      # We should have a cron job entry line at this point.
      $entry = new Parth::CronEntry 'text' => $input ;
    }
  }
  while (! $entry) ;

  return $entry ;
}

1 ;
