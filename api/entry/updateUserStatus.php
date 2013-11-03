<?php
/**
 * ユーザのステータスを変更する
 */
require_once '../cntr/BingoTableManager.class.php';

$userid = $_REQUEST['userid'];
$tableid = $_REQUEST['tableid'];
$status = $_REQUEST['status'];
if (empty($userid) || empty($tableid)) {
    echo 'false';
    return;
}

if (empty($status)) {
    $status = '';
}

$obj = new BingoTableManager();
$result = $obj->updateUserStatus($userid, $tableid, $status);
if ($result == false) {
    echo 'false';
}else{
    echo 'true';
}
?>
