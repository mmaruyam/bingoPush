<?php
/**
 * テーブルのステータスを変更する
 */
require_once '../cntr/BingoTableManager.class.php';

$tableid = $_REQUEST['tableid'];
$status = $_REQUEST['status'];
if (empty($tableid)) {
    echo 'false';
    return;
}

if (empty($status)) {
    $status = 'wait';
}

$obj = new BingoTableManager();
$result = $obj->updateBingoStatus($tableid, $status);
if ($result == false) {
    echo 'false';
}else{
    echo 'true';
}
?>
