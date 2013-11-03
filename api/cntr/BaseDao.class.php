<?php
class BaseDao
{
    const INI_FILE_PATH = '../conf/database.ini';
    const DEFAULT_DB_KEY = 'prod_mysql';

    protected $conf;
    protected $dbh;
    function __construct() {
        $this->conf = parse_ini_file(self::INI_FILE_PATH, true);
    }

    protected function connect($keyName='') {
        if (empty($keyName) || isset($this->conf[$keyName]) == false) {
            $keyName = self::DEFAULT_DB_KEY;
        }
        $dbData = $this->conf[$keyName];

        $dsn = 'mysql:dbname='.$dbData['database'].';host='.$dbData['host'];
        try {
            $this->dbh = new PDO($dsn, $dbData['user'], $dbData['pass']);
        } catch (PDOException $e) {
            echo 'Connection failed: ' . $e->getMessage();
            return false;
        }

        return true;
    }

}

?>
