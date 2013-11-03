<?php
/**
 * BINGO に参加
 */
require_once '../cntr/BingoTableManager.class.php';

$userid = $_REQUEST['userid'];
$tableid = $_REQUEST['tableid'];
if (empty($userid) || empty($tableid)) {
    echo 'false';
    return;
}

$obj = new BingoTableManager();
$result = $obj->registUserToBingoTable($userid, $tableid);
if ($result == false) {
    echo 'false';
}else{
    echo 'true';
}
?>
