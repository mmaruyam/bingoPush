<?php
/*
 * $B4IM}<TMQ$NHV9f$rJV$9(BAPI
 */
require_once '../cntr/BingoTableManager.class.php';
require_once '../util/makeCardNumber.php';

$userid = '';
$tableid = (empty($_REQUEST['tableid'])) ? '' : $_REQUEST['tableid'];

$obj = new BingoTableManager();
$data = $obj->getMasterTableData($userid, $tableid);
if ($data == false) {
    echo 'false';
    return;
}
print_r($data[0]['number']);
?>
