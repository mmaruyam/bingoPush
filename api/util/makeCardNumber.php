<?php
/*
 * $B4IM}<TMQ$NHV9f$r@8@.(B
 */
function makeMasterNumber() {
    $aryList = range(1, 75);
    shuffle($aryList);

    return $aryList;
}

/*
 * $B%f!<%6MQ$NHV9f$r@8@.(B
 */
function makeUserNumber() {
    $result = array();
    for ($i=0; $i<5; $i++) {
        $aryRow = array();
        $intAddNum = $i * 15;
        $aryList = range(1 + $intAddNum, 15 + $intAddNum);

        shuffle($aryList);
        for ($j=0; $j<5; $j++) {
            $aryRow[] = $aryList[$j];
        }

        $result[] = $aryRow;
    }

    return $result;
}
?>
