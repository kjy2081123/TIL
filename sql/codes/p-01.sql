use practice;

create table userinfo (
	id int auto_increment primary key,
    nickname varchar(20) not null,
    phone varchar(11) unique,
    reg_date date default(current_date)
);
show tables;

desc userinfo; -- ;까먹지 말것!!!!!!!!!!