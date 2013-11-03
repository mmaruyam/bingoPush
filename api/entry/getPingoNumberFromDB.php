<?php
/*
 * 管理者用の番号を返すAPI
 */
require_once '../cntr/BingoTableManager.class.php';
require_once '../util/makeCardNumber.php';

$userid = (empty($_REQUEST['userid'])) ? '' : $_REQUEST['userid'];
$tableid = (empty($_REQUEST['tableid'])) ? '' : $_REQUEST['tableid'];

$obj = new BingoTableManager();
$data = $obj->getMasterTableData($userid, $tableid);
print_r(json_encode($data));
?>
