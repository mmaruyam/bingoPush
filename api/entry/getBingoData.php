<?php
/**
 * $B4IM}Cf$N%F!<%V%k%G!<%?$r<hF@$9$k(B
 * tableid $B$r;XDj$7$?>l9g!"(B1$B7o$N$_<hF@$9$k$3$H$,$G$-$k(B
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
