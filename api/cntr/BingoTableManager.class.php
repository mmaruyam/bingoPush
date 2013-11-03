<?php
require_once 'BaseDao.class.php';
require_once '../util/makeCardNumber.php';

define('QUERY_DIR_PATH', '../conf/query/masterTable/');

class BingoTableManager extends BaseDao
{
    //------------------------------------
    // Const
    //------------------------------------
    const TEMP_TABLE_NAME_FORMAT = 'pingo_%s';
    const DELETE_DATA_FROM_ID_QUERY = 'DELETE FROM `bingo_master` WHERE id = :id)';
    const GET_BINGO_STATUS_QUERY = 'SELECT * FROM `:tableId`';
    const UPDATE_BINGO_STATUS_QUERY = 'UPDATE `bingo_master` SET status=:status WHERE id = :id';
    const UPDATE_PUSHED_NUMBER_INDEX_QUERY = 'UPDATE `bingo_master` SET num_idx=:num_idx WHERE id = :id';
    const GET_BINGO_DATA_FROM_MASTER_BY_USERID_QUERY = 'SELECT * FROM `bingo_master` WHERE manager_id = :userid';
    const GET_BINGO_DATA_FROM_MASTER_BY_ID_QUERY = 'SELECT * FROM `bingo_master` WHERE id = :id';

    const GET_USER_STATUS_QUERY = 'SELECT * FROM `%s` WHERE userid = :userid';
    const GET_REACH_AND_BINGO_COUNT_QUERY = 'SELECT status, count(*) as count FROM %s GROUP BY status';
    const UPDATE_USER_STATUS_QUERY = 'UPDATE `%s` SET status=:status WHERE userid = :userid';
    const GET_PUSH_USER_TOKEN_LIST = 'SELECT userid, token FROM %s left join user on %s.userid = user.id';

    //------------------------------------
    // Member variables
    //------------------------------------
    private $_error = array();

    //------------------------------------
    // Construct
    //------------------------------------
    public function __construct() {
        parent::__construct();
        $this->connect();
    }

    //------------------------------------
    // Master Table
    //------------------------------------
    /* BINGO $B%F!<%V%k@8@.(B */
    public function createBingoTable($userid) {
        // master number make
        $aryMasterNumber = makeMasterNumber();
        $strMasterNumber = json_encode($aryMasterNumber);

        // table $B>pJs3JG<(B
        $query = file_get_contents(QUERY_DIR_PATH . 'insert_table_data.sql');
        $sth = $this->dbh->prepare($query);
        $sth->bindValue(':userid', $userid);
        $sth->bindValue(':number', $strMasterNumber);
        $result = $sth->execute();
        if ($result == false) {
            $this->_error = $sth->errorInfo();
            error_log('failed to insert table info');
            error_log(sprintf('[%s] %s', $this->_error[0], $this->_error[2]));
            return false;
        }

        // insert $B$7$?%G!<%?$N(Bid $B<hF@(B
        $id = $this->dbh->lastInsertId();
        $tableName = sprintf(self::TEMP_TABLE_NAME_FORMAT, $id);

        // create table
        $queryFormat = file_get_contents(QUERY_DIR_PATH . 'create_table_format.sql');
        $query = sprintf($queryFormat, $tableName);
        $sth = $this->dbh->prepare($query);
        $sth->bindValue(':table_name', $tableName);
        $result = $sth->execute();
        if ($result == false) {
            // delete data
            $this->deleteTableInfo($id);

            // error
            $this->_error = $sth->errorInfo();
            error_log('failed to create table');
            error_log(sprintf('[%s] %s', $this->_error[0], $this->_error[2]));
            return false;
        }

        return $id;
    }

    /* Master table $B$+$i%l%3!<%I:o=|(B */
    public function deleteTableInfo($id) {
        $sth = $this->dbh->prepare(self::DELETE_DATA_FROM_ID_QUERY);
        $sth->bindValue(':id', $id);
        return $sth->execute();
    }

    /* User $B$r(B temp table $B$KEPO?$9$k(B */
    public function registUserToBingoTable($userId, $tableId) {
        $tableName = sprintf(self::TEMP_TABLE_NAME_FORMAT, $tableId);

        // check table status
        $query = sprintf('SELECT * FROM bingo_master WHERE id = :tableid');
        $sth = $this->dbh->prepare($query);
        $sth->bindValue(':tableid', $tableId);
        $result = $sth->execute();
        if ($result == false) {
            error_log('failed to select table');
            return false;
        }

        // $B<hF@7o?t%A%'%C%/(B
        $result = $sth->fetch();
        if ($result == false) {
            error_log('no match data');
            var_dump($result);
            return false;
        }

        // $B%9%F!<%?%9!"5Z$S(Bdelete$B%U%i%0%A%'%C%/(B
        if ($result['status'] == 'done' || $result['delete'] == 1) {
            error_log('can\'t join to the table['.$tableId.']');
            return false;
        }

        // insert query
        $query = sprintf('INSERT INTO %s(userid) VALUE(:userid)', $tableName);
        $sth = $this->dbh->prepare($query);
        $sth->bindValue(':userid', $userId);
        $result = $sth->execute();
        if ($result == false) {
            $this->_error = $sth->errorInfo();
            error_log(sprintf('[%s] %s', $this->_error[0], $this->_error[2]));
            error_log('failed to insert user into bingo table');
            return false;
        }

        return true;
    }

    /* $B4IM}Cf$N%F!<%V%k%9%F!<%?%9$rJQ99(B */
    public function updateBingoStatus($tableId, $status) {
        $sth = $this->dbh->prepare(self::UPDATE_BINGO_STATUS_QUERY);
        $sth->bindValue(':id', $tableId);
        $sth->bindValue(':status', $status);
        $result = $sth->execute();

        return $result;
    }

    /* push $BDLCN$rAw$C$?HV9f$N(Bindex $B99?7(B */
    public function updatePushedNumberIndex($tableId, $index) {
        $sth = $this->dbh->prepare(self::UPDATE_PUSHED_NUMBER_INDEX_QUERY);
        $sth->bindValue(':id', $tableId);
        $sth->bindValue(':num_idx', $index);
        $result = $sth->execute();
        if ($result == false) {
            $this->_error = $sth->errorInfo();
            error_log('failed to update num_idx');
            error_log(sprintf('[%s] %s', $this->_error[0], $this->_error[2]));
            return false;
        }

        return $result;
    }

    /* Master Table $B>pJs$r<hF@(B */
    public function getMasterTableData($userId='', $tableId='') {
        if (empty($userId) && empty($tableId)) {
            error_log('available value is not exists. userId or tableId is neccessary.');
            return false;
        }

        if (empty($tableId) == false) {
            $id = $tableId;
            $bind = ':id';
            $query = self::GET_BINGO_DATA_FROM_MASTER_BY_ID_QUERY;
        }else{
            $id = $userId;
            $bind = ':userid';
            $query = self::GET_BINGO_DATA_FROM_MASTER_BY_USERID_QUERY;
        }
        $sth = $this->dbh->prepare($query);
        $sth->bindValue($bind, $id);
        $result = $sth->execute();
        if ($result == false) {
            error_log('failed to get master data');
            return false;
        }

        $result = $sth->fetchAll();

        return $result;
    }

    /* $BDLCN$5$l$?$H$3$m$^$G$NHV9f$rA4$F<hF@(B */
    public function getPushedNumber($tableid) {
        // status check

        // $BDLCN:Q$_$NHV9f$rAw?.(B
        $data = $this->getMasterTableData('', $tableid);
        if (count($data) != 1) {
            return false;
        }

        $numbers = json_decode($data[0]['number']);
        $index = $data[0]['num_idx'];
        if ($index == NULL) {
            return array();
        }

        $aryList = array_slice($numbers, 0, $index+1);
        return $aryList;
    }

    //------------------------------------
    // Temp Table
    //------------------------------------
    /* $B%f!<%6%9%F!<%?%9>pJs$r<hF@(B */
    public function getUserStatus($userId, $tableId) {
        $tableName = sprintf(self::TEMP_TABLE_NAME_FORMAT, $tableId);
        $query = sprintf(self::GET_USER_STATUS_QUERY, $tableName);
        $sth = $this->dbh->prepare($query);
        $sth->bindValue(':userid', $userId);
        $result = $sth->execute();
        if ($result == false) {
            error_log('failed to get user satatus');
            return false;
        }

        $result = $sth->fetchAll();

        return $result;
    }

    /* $B%f!<%6%9%F!<%?%9$r99?7(B */
    public function updateUserStatus($userId, $tableId, $status) {
        $tableName = sprintf(self::TEMP_TABLE_NAME_FORMAT, $tableId);
        $query = sprintf(self::UPDATE_USER_STATUS_QUERY, $tableName);
        $sth = $this->dbh->prepare($query);
        $sth->bindValue(':userid', $userId);
        $sth->bindValue(':status', $status);
        $result = $sth->execute();
        
        return $result;
    }

    public function getUserStatusCountInfo($tableId) {
        $tableName = sprintf(self::TEMP_TABLE_NAME_FORMAT, $tableId);
        $query = sprintf(self::GET_REACH_AND_BINGO_COUNT_QUERY, $tableName);
        $sth = $this->dbh->prepare($query);
        $result = $sth->execute();
        if ($result == false) {
            error_log('failed to get reach and bingo count');
            return false;
        }
        $result = $sth->fetchAll();

        $aryCountList = array();
        $total = 0;
        foreach ($result as $detail) {
            if (empty($detail['status'])) {
                $detail['status'] = 'other';
            }
            $aryCountList[$detail['status']] = (int)$detail['count'];
            $total += (int)$detail['count'];
        }
        $aryCountList['total'] = $total;

        return $aryCountList;
    }

    public function dropPingoTable($tableId) {
        $tableName = sprintf(self::TEMP_TABLE_NAME_FORMAT, $tableId);
    }

    public function getPushUserTokenList($tableId) {
        $tableName = sprintf(self::TEMP_TABLE_NAME_FORMAT, $tableId);
        $query = sprintf(self::GET_PUSH_USER_TOKEN_LIST, $tableName, $tableName);
        $sth = $this->dbh->prepare($query);
        $result = $sth->execute();
        if ($result == false) {
            $this->_error = $sth->errorInfo();
            error_log('failed to insert table info');
            error_log(sprintf('[%s] %s', $this->_error[0], $this->_error[2]));
            return false;
        }

        $result = $sth->fetchAll();
        $aryList = array();
        foreach ($result as $key => $data) {
            $aryTemp = array();
            foreach ($data as $idx => $detail) {
                if (is_numeric($idx)) {
                    continue;
                }

                $aryTemp[$idx] = $detail;
            }
            $aryList[] = $aryTemp;
        }

        return $aryList;
    }

}
// $obj = new BingoTableManager();
//-- create table
// $result = $obj->createBingoTable(100001714149333);
// if ($result == false) {
//     echo 'error';
//     return;
// }

//-- insert user into temp table
// $result = $obj->registUserToBingoTable(100001714149333, 35);
// var_dump($result);

//-- get reach and bingo count
// $result = $obj->getUserStatusCountInfo(39);
// var_dump($result);
?>
