<?php
require_once '../cntr/BingoTableManager.class.php';

$tableid = $_REQUEST['tableid'];
$index = $_REQUEST['index'];

if (empty($tableid) || empty($index)) {
    echo 'false';
    return;
}

$obj = new BingoTableManager();
$result = $obj->updatePushedNumberIndex($tableid, $index);
if ($result == false) {
    echo 'false';
}else{
    echo 'true';
}

?>
