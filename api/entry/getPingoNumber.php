<?php
/*
 * $B4IM}<TMQ$NHV9f$rJV$9(BAPI
 */
require_once '../util/makeCardNumber.php';
$aryList = makeMasterNumber();
sleep(2);
print_r(json_encode($aryList));
?>
