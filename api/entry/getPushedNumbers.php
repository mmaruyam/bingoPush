<?php
require_once '../cntr/BingoTableManager.class.php';

$tableid = $_REQUEST['tableid'];
if (empty($tableid)) {
    echo 'false';
    return;
}

$obj = new BingoTableManager();
$numbers = $obj->getPushedNumber($tableid);
print_r(json_encode($numbers));
?>
