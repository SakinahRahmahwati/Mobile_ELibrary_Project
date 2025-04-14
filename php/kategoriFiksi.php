<?php
include_once'dbconnect_sakinah.php';
$stat = $conn->prepare("SELECT id, judul, penulis, kode_buku, kategori, jumlah, gambar, deskripsi FROM buku WHERE kategori = 'fiksi';");
$stat -> execute();
$stat -> bind_result($id, $judul, $penulis, $kode_buku, $kategori, $jumlah, $gambar, $deskripsi);
$arraybuku = array();
while ($stat -> fetch()){
    $databuku = array();
    $databuku ['id']= $id;
    $databuku ['judul']= $judul;
    $databuku ['penulis']= $penulis;
    $databuku ['kode_buku']= $kode_buku;
    $databuku ['kategori']= $kategori;
    $databuku ['jumlah']= $jumlah;
    $databuku ['gambar']= $gambar;
    $databuku ['deskripsi']= $deskripsi;
    array_push($arraybuku, $databuku);
}
echo json_encode($arraybuku);