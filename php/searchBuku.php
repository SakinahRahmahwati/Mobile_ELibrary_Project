<?php
include_once 'dbconnect_sakinah.php';
$query = $_GET['query'];

$sql = "SELECT * FROM buku WHERE judul LIKE '%$query%' OR penulis LIKE '%$query%' OR kode_buku LIKE '%$query%' OR kategori LIKE '%$query%' OR deskripsi LIKE '%$query%' ";
$execute = mysqli_query($conn, $sql);

$searchBuku = array();
while($rows = $execute ->fetch_assoc()){
    $searchBuku[] = $rows;
}
echo json_encode($searchBuku);

?>