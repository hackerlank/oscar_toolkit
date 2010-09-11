create table tbl_role
(
	id int(11) unsigned not null auto_increment,
	money int(11) unsigned not null,
	level int(11) unsigned not null,
	primark key (id),
)engine = myisam;