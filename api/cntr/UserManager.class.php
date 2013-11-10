<?php
require_once 'BaseDao.class.php';

class UserManager extends BaseDao
{
    const REGIST_USER_INFO_QUERY = 'INSERT INTO `user`(id, name, token) VALUE(:id, :name, :token)';
    const GET_USER_INFO_QUERY = 'SELECT * FROM `user` WHERE id = :id';

    private $_error;

    public function __construct() {
        parent::__construct();
        $this->_error = array();
    }

    public function registUserInfo($id, $name, $token) {
        $this->connect();
        $sth = $this->dbh->prepare(self::REGIST_USER_INFO_QUERY);
        $sth->bindValue(':id', $id);
        $sth->bindValue(':name', $name);
        $sth->bindValue(':token', $token);
        $result = $sth->execute();

        return $result;
    }

    public function getUserInfo($id) {
        $sth = $this->dbh->prepare(self::GET_USER_INFO_QUERY);
        $sth->bind(':id', $id);
        $result = $sth->execute();
        if ($result == false) {
            $this->_error = $sth->errorInfo();
            return false;
        }

        return $sth->fetchAll(PDO::FETCH_COLUMN|PDO::FETCH_GROUP);
    }

    public function getError() {
        return $this->_error;
    }
}
?>
