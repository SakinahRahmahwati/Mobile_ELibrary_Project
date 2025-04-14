<?php
include_once'dbconnect_sakinah.php';
$stat = $conn->prepare("SELECT 
        peminjaman.id, 
        peminjaman.nama_peminjam, 
        buku.kode_buku, 
        buku.judul AS judul_buku, 
        peminjaman.tanggal_peminjaman, 
        peminjaman.batas_pengembalian
    FROM peminjaman
    INNER JOIN buku ON peminjaman.buku_id = buku.id ORDER BY peminjaman.created_at DESC");
$stat -> execute();
$stat -> bind_result($id, $nama_peminjam, $kode_buku, $judul_buku, $tanggal_peminjaman, $batas_pengembalian);
$arraypinjam = array();
while ($stat -> fetch()){
    $datapinjam = array();
    $datapinjam ['id']= $id;
    $datapinjam ['nama_peminjam']= $nama_peminjam;
    $datapinjam ['kode_buku']= $kode_buku;
    $datapinjam ['judul_buku']= $judul_buku;
    $datapinjam ['tanggal_peminjaman']= $tanggal_peminjaman;
    $datapinjam ['batas_pengembalian']= $batas_pengembalian;
    array_push($arraypinjam, $datapinjam);
}
echo json_encode($arraypinjam);