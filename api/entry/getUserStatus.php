<?php
/**
 * ユーザのビンゴステータス情報取得
 */
require_once '../cntr/BingoTableManager.class.php';

$userid = $_REQUEST['userid'];
$tableid = $_REQUEST['tableid'];
if (empty($userid) || empty($tableid)) {
    echo 'false';
    return;
}

$obj = new BingoTableManager();
$result = $obj->getUserStatus($userid, $tableid);
if ($result == false) {
    echo 'false';
    return;
}
echo json_encode($result);
?>
