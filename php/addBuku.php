<?php
include_once 'dbconnect_sakinah.php';
$judul = $_POST['judul'];
$penulis = $_POST['penulis'];
$kode_buku = $_POST['kode_buku'];
$kategori = $_POST['kategori'];
$jumlah = $_POST['jumlah'];
$gambar = $_POST['gambar'];
$deskripsi = $_POST['deskripsi'];

if(!$judul || !$penulis || !$kode_buku || !$kategori || !$jumlah || !$gambar || !$deskripsi){
    echo json_encode(array('message'=>'isi semua kolom'));
}else{
    $query = "INSERT INTO buku (judul, penulis, kode_buku, kategori, jumlah, gambar, deskripsi) VALUES('$judul', '$penulis','$kode_buku', '$kategori', '$jumlah', '$gambar', '$deskripsi')";
    $exec = mysqli_query($conn, $query);
    if($exec){
        echo json_encode(array('message'=>'buku baru sukses ditambahkan'));
    }else{
        echo json_encode(array('message'=>'buku baru gagal ditambahkan'));
    }
}


?>

