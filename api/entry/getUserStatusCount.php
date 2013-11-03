<?php
require_once '../cntr/BingoTableManager.class.php';

$tableid = $_REQUEST['tableid'];
if (empty($tableid)) {
    echo 'false';
    return;
}

$obj = new BingoTableManager();
$tableId = $obj->getUserStatusCountInfo($tableid);
echo json_encode($tableId);

?>
