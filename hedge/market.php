<?php

ob_start();

$base = 19000;
$step = 125;
$cnt  = 9;
$options = array();
$hit = mt_rand(0, $cnt-1);

for ($i=0; $i<$cnt; $i++) {
    $atm = $i == $hit? true: false;
    $delta = round(mt_rand()/mt_getrandmax(), 4);
    $delta = $i == $hit? 0.5003: $delta;

    $cp = array("call", "put");
    foreach ($cp as $value) {
        $new = array(
                'k'=>$base+$i*$step,
                'expire'=>'20170608',
                'type'=>$value,
                'price'=>mt_rand(20, 40),
                'atm'=>$atm,
                'delta'=>$delta
        );
        $options[] = $new;
        $delta = (-1)*(1-$delta);
    }
}

//
$hedges = array();
$type = array("SC_BP", "BC_SP");

foreach ($type as $value) {
    $bullCd = "1570";
    $bullPrice = mt_rand(14820, 15230);
    $bearCd = "1357";
    $bearPrice = mt_rand(1750, 1820);

    if (strcmp($type[1], $value)==0) {
        list($bullCd, $bearCd) = array($bearCd, $bullCd);
        list($bullPrice, $bearPrice) = array($bearPrice, $bullPrice);
    }

    $new = array(
            'bull'=>array(
                'code'=>$bullCd,
                'price'=>$bullPrice
            ),
            'bear'=>array(
                'code'=>$bearCd,
                'price'=>$bearPrice
            ),
            'hedgesType'=>$value
    );
    $hedges[] = $new;
}

$market = array(
    'timestamp'=>date('Y/m/d H:i:s'),
    'options'=>$options,
    'hedges'=>$hedges
);

echo json_encode($market);

$length = ob_get_length();

header("Content-Type: application/json; charset=UTF-8");
header("Content-Length:".$length."\r\n");
header("Accept-Ranges: bytes"."\r\n");

ob_end_flush();

?>