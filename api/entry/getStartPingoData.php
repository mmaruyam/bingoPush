<?php
/*
 * $B4IM}<TMQ$N%S%s%4%G!<%?$rJV$9(BAPI
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
$result = array();
$result['number'] = unserialize($data[0]['number']);
$result['index'] = $data[0]['num_idx'];
print_r(json_encode($result));
?>
