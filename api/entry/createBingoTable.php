<?php
/**
 * BINGO $B%F!<%V%k@8@.(BAPI
 */
require_once '../cntr/BingoTableManager.class.php';

$userid = $_REQUEST['userid'];
if (empty($userid)) {
    echo 'false';
    return;
}

$obj = new BingoTableManager();
$tableId = $obj->createBingoTable($userid);
if ($tableId == false) {
    echo 'false';
    return;
}
echo $tableId;
?>
