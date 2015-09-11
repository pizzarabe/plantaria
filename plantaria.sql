create database plantaria;
  use 'plantaria';
  create table user (user_id Int NOT NULL AUTO_INCREMENT ,
  username varchar(255) NOT NULL UNIQUE ,
  firstname varchar(255) ,
  lastname varchar(255) ,
  usergroup_id int NOT NULL UNIQUE ,
  lastlogin TIMESTAMP ,
  passwort varchar(255) NOT NULL ,
  salt varchar(255) NOT NULL ,
  email varchar(255) ,
  PRIMARY KEY (user_id)
  );


    create table sensor (sensor_id INT NOT NULL AUTO_INCREMENT ,
    node_id INT NOT NULL UNIQUE ,
    sensor_type enum('light','temperatur','moisture') ,
    plant_id INT,
    intervall INT Default '60',
    threshold_min double ,
    threshold_max double ,
    notification boolean ,
    PRIMARY KEY (sensor_id)
    );
      create table plant (plant_id INT NOT NULL AUTO_INCREMENT ,
      plant_name varchar(255) NOT NULL UNIQUE ,
      description text ,
      PRIMARY KEY (plant_id)
      );
        create table node (node_id INT NOT NULL AUTO_INCREMENT ,
        nodename varchar(255) NOT NULL UNIQUE ,
        status enum('online','offline','disabled') NOT NULL ,
        fireware_version varchar(255),
        systemmodel varchar(255),
        uptime time,
        PRIMARY KEY (node_id)
        );

          create table usergroup (usergroup_id INT NOT NULL AUTO_INCREMENT ,
          usergroupname varchar(255) NOT NULL UNIQUE ,
          PRIMARY KEY (usergroup_id)
          );
            create table data (data_id INT NOT NULL AUTO_INCREMENT ,
            timestamp TIME NOT NULL ,
            sensor_id INT NOT NULL ,
            data DOUBLE NOT NULL ,
            unit varchar(255) NOT NULL ,
            PRIMARY KEY (data_id)
            );



ALTER TABLE user
add (FOREIGN KEY (usergroup_id)
REFERENCES usergroup(usergroup_id)
);

ALTER TABLE sensor
add (FOREIGN KEY (node_id)
REFERENCES node(node_id)
);

ALTER TABLE data
add (FOREIGN KEY (sensor_id)
REFERENCES sensor(sensor_id)
);

ALTER TABLE sensor
add (FOREIGN KEY (plant_id)
REFERENCES plant(plant_id)
);

Insert into usergroup values('1','system'),('2','admin'),('3','user'),('4','guest');

/*
Insert into user values('1','system','','','1','',''),('2','root','','','2','','root@localhost');
*/
