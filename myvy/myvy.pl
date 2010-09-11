##!/usr/bin/perl
use strict;
use DBI;
use Getopt::Long();
use Data::Dumper;



#输入参数
my $db0 = 'game_0';
my $db1 ='game_1';
my $host = 'localhost';
my $user = 'root';
my $password = '123456';




my $dbh = DBI->connect("DBI:mysql:database=mysql;host=".$host, $user, $password) || die "can't connect to DB";






#字段个数
sub count_columns
{
	my $schema = $_[0];
	my $sql = $dbh->prepare(qq{select count(*) from information_schema.COLUMNS where TABLE_SCHEMA = '$schema'});
	$sql->execute();
	my $count = $sql->fetchrow_array();
	$sql->finish();
	return $count;
}

#输入
sub verify
{
	my $ret = 1;
	my $result0 = $dbh->selectall_arrayref(qq{select * from information_schema.COLUMNS where TABLE_SCHEMA = '$db0'}, {Slice => {}});
	my $result1 = $dbh->selectall_arrayref(qq{select * from information_schema.COLUMNS where TABLE_SCHEMA = '$db1'}, {Slice => {}});

	print Data::Dumper->Dumper($result0);
	for(my $index = 0; $index < @{$result1}; ++$index)
	{
		my $hashref1 = ${$result1}[$index];
		my $hashref0 = ${$result0}[$index];
		while(my ($key, $value) = each %{$hashref1})
		{
			if($value != $hashref0->{$key})
			{
				$ret = 0;
				print "$key 不匹配\n";
				return $ret;
			}
		}
	}

	return $ret;
}




print count_columns($db0),"\n";
print count_columns($db1),"\n";
print verify();


$dbh->disconnect();
