DROP TABLE IF EXISTS photographer CASCADE;
DROP TABLE IF EXISTS photography CASCADE;
DROP TABLE IF EXISTS photographycopy CASCADE;
DROP TABLE IF EXISTS pricehistory CASCADE;
DROP TABLE IF EXISTS address CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS review CASCADE;
DROP TABLE IF EXISTS command CASCADE;
DROP TABLE IF EXISTS shoppingcartelem CASCADE;
DROP TABLE IF EXISTS return_product CASCADE;

create table photographer (
    photographer_id serial,
    firstname varchar(50) NOT NULL,
    lastname varchar(50) NOT NULL,
    phone varchar(10) unique,
    primary key (photographer_id)
);

create table photography (
    pid serial,
    title varchar (100) NOT NULL,
    photographer_id integer NOT NULL,
    url varchar (500) NOT NULL,
    print_price integer NOT NULL,
    digital_price integer NOT NULL,
    creation_date timestamp NOT NULL,
    primary key (pid),
    foreign key (photographer_id) references photographer(photographer_id),
    check (print_price > 0),
    check (digital_price > 0)
);

create table photographycopy (
    copy_id serial,
    pid integer NOT NULL,
    photo_type integer NOT NULL , -- Changement type -> photography_type
    format varchar (50) ,
    photo_size varchar (50), -- Changement size -> photo_size
    is_available boolean,
    deadline timestamp,
    quantity integer,
    primary key (copy_id),
    foreign key (pid) references photography(pid),
    check (photo_type in (0,1)), --  1 = Digital, 0 = Print
    check (not (photo_type = 1) or not (format is NULL)),
    check (not (photo_type = 0) or not (photo_size is NULL)),
    check (photo_type = 1 or ((is_available and quantity > 0 ) or (not is_available and quantity = 0))),
    check (deadline is NULL or (not is_available))
);

create table pricehistory (
    pid integer,
    change_date timestamp, -- Changement date -> change_date
    print_price integer NOT NULL,
    digital_price integer NOT NULL,
    primary key (pid, change_date),
    foreign key (pid) references photography(pid),
    check (print_price > 0 and digital_price > 0)
);

create table address (
    aid serial,
    street_nb integer NOT NULL,
    street_name varchar (100) NOT NULL,
    city varchar (100) NOT NULL,
    country varchar (100) NOT NULL,
    primary key (aid),
    check (street_nb >= 0)
);

create table client (
    email varchar(100),
    password varchar (100) NOT NULL,
    firstname varchar (100) NOT NULL,
    lastname varchar (100) NOT NULL,
    address integer NOT NULL,
    phone varchar (10),
    registration_date timestamp NOT NULL,
    primary key (email),
    foreign key (address) references address(aid)
);

create table review (
    email varchar(100),
    copy_id integer,
    rate integer NOT NULL,
    remark text, -- Changement comment -> remark
    review_date timestamp,
    primary key (email, copy_id),
    foreign key (email) references client(email),
    foreign key (copy_id) references photographycopy(copy_id),
    check (0 <= rate and rate <= 10)
);

create table command ( -- Changement order -> command
    cmd_id serial,
    email varchar (100) NOT NULL,
    command_date timestamp NOT NULL, -- Changement date -> command_date
    shipping_addr integer NOT NULL,
    billing_addr integer,
    is_payable_by_cheque boolean NOT NULL,
    is_payed boolean NOT NULL,
    primary key (cmd_id),
    foreign key (email) references client(email),
    foreign key (shipping_addr) references address(aid),
    foreign key (billing_addr) references address(aid)
);

create table shoppingcartelem (
    elem_id serial,
    email varchar (100) NOT NULL,
    copy_id integer NOT NULL,
    quantity integer NOT NULL,
    cmd_id integer,
    status integer NOT NULL,
    shipping_date timestamp,
    delivery_date timestamp,
    primary key (elem_id),
    foreign key (email) references client(email),
    foreign key (copy_id) references photographycopy(copy_id),
    foreign key (cmd_id) references command(cmd_id),
    check (-1 <= status and status <= 4), --  -1 = Not ordered, 0 = Pending, 1 = Preparing, 2 = InDelivery, 3 = Delivered, 4 = Cancelled
    check (not (status >= 0) or not (cmd_id is NULL)),
    check (not (status >= 2) or (not (shipping_date is NULL))),
    check (not (status >= 3) or (not (delivery_date is NULL))),
    check (shipping_date <= delivery_date),
    check (0 <= quantity)
);

create table return_product ( -- Changement return -> return_product
    elem_id integer,
    cmd_id integer,
    return_date timestamp not NULL, -- Changement date -> return_date
    issue text,
    primary key (elem_id,cmd_id),
    foreign key (elem_id) references shoppingcartelem(elem_id),
    foreign key (cmd_id) references command(cmd_id)
);

