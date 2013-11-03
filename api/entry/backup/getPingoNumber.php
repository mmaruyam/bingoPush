<?php
$result = array();
for ($i=0; $i<5; $i++) {
    $aryRow = array();
    $intAddNum = $i * 15;
    $aryList = range(1 + $intAddNum, 15 + $intAddNum);

    shuffle($aryList);
    for ($j=0; $j<5; $j++) {
        $aryRow[] = $aryList[$j];
    }

    $result[] = '[' . implode(',', $aryRow) . ']';
}
// print_r($result);

$strNumbers = '[' . implode(',', $result) . ']';
print_r($strNumbers);
echo "\n";
?>
