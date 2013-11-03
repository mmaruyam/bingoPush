CREATE TABLE %s (
  `userid` bigint(20) NOT NULL,
  `status` varchar(16) DEFAULT NULL,
  `number` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`userid`),
  FOREIGN KEY (`userid`) REFERENCES `user`(`id`)
  ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
