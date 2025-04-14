<?php
include_once 'dbconnect_sakinah.php';

$query = $_GET['query'];

$sql = "SELECT 
            peminjaman.id, 
            peminjaman.nama_peminjam AS nama_peminjam, 
            buku.kode_buku AS kode_buku, 
            buku.judul AS judul_buku, 
            peminjaman.tanggal_peminjaman AS tanggal_peminjaman, 
            peminjaman.batas_pengembalian AS batas_pengembalian
        FROM peminjaman
        INNER JOIN buku ON peminjaman.buku_id = buku.id
        WHERE peminjaman.nama_peminjam LIKE '%$query%' 
        OR peminjaman.tanggal_peminjaman LIKE '%$query%' 
        OR buku.judul LIKE '%$query%' 
        OR peminjaman.batas_pengembalian LIKE '%$query%'";

$execute = mysqli_query($conn, $sql);

$searchPinjam = array();
while($rows = $execute ->fetch_assoc()){
    $searchPinjam[] = $rows;
}

echo json_encode($searchPinjam);
?>
