<?php
require_once '../cntr/BingoTableManager.class.php';

$tableid = $_REQUEST['tableid'];
$index = $_REQUEST['index'];

error_log(print_r($index, true));

if (empty($tableid) || (empty($index) && $index!=='0')) {
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
