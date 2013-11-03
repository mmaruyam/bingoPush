<?php
/**
 * 管理中のテーブルデータを取得する
 * tableid を指定した場合、1件のみ取得することができる
 */
require_once '../cntr/BingoTableManager.class.php';

$userid = $_REQUEST['userid'];
$tableid = $_REQUEST['tableid'];

/*
if (empty($tableid)) {
    echo 'false';
    return;
}
*/

$obj = new BingoTableManager();
$tableId = $obj->getMasterTableData($userid, $tableid);
echo json_encode($tableId);

?>
