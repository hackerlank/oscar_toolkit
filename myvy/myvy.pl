#!/usr/bin/perl -w
use strict;
use DBI;
use Getopt::Long();
use Data::Dumper;

$Getopt::Long::ignorecase = 0;
$Getopt::Long::bundling = 1;

#{table_name 
#       => {
#           column_name_1 => row_ref,
#           column_name_2 => row_ref
#          }
#}
sub collect_data
{
    my $dbh = shift;
    my $schema = shift;
    my $data_ref = {};
    my $sql = qq{select TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, ORDINAL_POSITION, IS_NULLABLE,DATA_TYPE from information_schema.COLUMNS  
    where TABLE_SCHEMA = '$schema'};

    my $sth = $dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array())
    {
        $data_ref->{$row[0]}{$row[1]} = \@row;
    }
    #print Data::Dumper->Dumper($data_ref);
    return $data_ref;
}

#verif the meta data collections
sub verify
{
    my $target_ref = shift;
    my $source_ref = shift;

    my $ret = 1;
    while( my ($table, $columns) = each %$target_ref)
    {
        if(exists $source_ref->{$table})
        {
            while( my ($column, $row_ref) = each %$columns)
            {
                my $row1_ref = $source_ref->{$table}{$column};
                if(defined $row1_ref)
                {
                    if($row_ref->[2] ne $row1_ref->[2])
                    {
                        print "not the same column: COLUMN_TYPE $table, $column", "\n";
                        $ret = 0;

                    }elsif($row_ref->[3] ne $row1_ref->[3])
                    {
                        print "not the same column: ORDINAL_POSITION $table, $column", "\n";
                        $ret = 0;

                    }elsif($row_ref->[4] ne $row1_ref->[4])
                    {
                        print "not the same column: IS_NULLABLE $table, $column", "\n";
                        $ret = 0;

                    }elsif($row_ref->[5] ne $row1_ref->[5])
                    {
                        print "not the same column: DATA_TYPE $table, $column", "\n";
                        $ret = 0;

                    }else
                    {
                        #print "the same column: $table, $column", "\n";

                    }

                }else
                {
                    print "no column: $table, $column", "\n";
                    $ret = 0;
                }
            }

        }else
        {
            print "no table: $table","\n";
            $ret = 0;
        }
    }
    return $ret;
}



#default parameters
my ($host, $user, $password, $targetdb, $sourcedb) = ("192.168.111.128", "rat", "tar", "game_1", "game_0");

Getopt::Long::GetOptions(
    "host|h=s"  =>  \$host,
    "user|u=s"  =>  \$user,
    "password|p=s"  =>  \$password,
    "target|t=s"    =>  \$targetdb,
    "source|s=s"    =>  \$sourcedb
) or exit (1);


my $dbh = DBI->connect("DBI:mysql:database=mysql;host=".$host, $user, $password) || die "can't connect to DB";


if(verify( collect_data($dbh, $targetdb), collect_data($dbh, $sourcedb)))
{
    print "$sourcedb is the same to $targetdb", "\n";
}else
{
    print "$sourcedb is not the same to $targetdb", "\n";
}


$dbh->disconnect();
