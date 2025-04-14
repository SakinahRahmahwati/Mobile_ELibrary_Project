<?php
include_once 'dbconnect_sakinah.php';

if (isset($_POST["id"])){
    $id = $_POST["id"];
}else{
    return;
}

$query = "DELETE FROM buku WHERE id= '$id'";
$execute = mysqli_query($conn, $query);
$arrproduct = [];

if ($execute){
    $arrproduct ["Berhasil dihapus"] = true;
}else{
    $arrproduct["Gagal Dihapus"] = false;
}

echo json_encode($arrproduct);

?>