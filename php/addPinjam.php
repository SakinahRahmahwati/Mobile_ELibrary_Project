<?php
include_once 'dbconnect_sakinah.php';

$nama_peminjam = $_POST['nama_peminjam'];
$buku_id = $_POST['buku_id'];
$tanggal_peminjaman = $_POST['tanggal_peminjaman'];
$batas_pengembalian = date('Y-m-d', strtotime($tanggal_peminjaman . ' +7 days'));

if (!$nama_peminjam || !$buku_id || !$tanggal_peminjaman) {
    echo json_encode(array('message' => 'Isi semua kolom'));
    exit;
}

$cek_buku_query = "SELECT jumlah FROM buku WHERE id = '$buku_id'";
$cek_buku_result = mysqli_query($conn, $cek_buku_query);
if (!$cek_buku_result || mysqli_num_rows($cek_buku_result) == 0) {
    echo json_encode(array('message' => 'Buku tidak ditemukan'));
    exit;
}

$buku = mysqli_fetch_assoc($cek_buku_result);
if ($buku['jumlah'] <= 0) {
    echo json_encode(array('message' => 'Buku tidak tersedia untuk dipinjam'));
    exit;
}

$kurangi_buku_query = "UPDATE buku SET jumlah = jumlah - 1 WHERE id = '$buku_id'";
$kurangi_buku_exec = mysqli_query($conn, $kurangi_buku_query);
if (!$kurangi_buku_exec) {
    echo json_encode(array('message' => 'Gagal mengurangi jumlah buku'));
    exit;
}

$query = "INSERT INTO peminjaman (nama_peminjam, buku_id, tanggal_peminjaman, batas_pengembalian) 
          VALUES ('$nama_peminjam', '$buku_id', '$tanggal_peminjaman', '$batas_pengembalian')";
$exec = mysqli_query($conn, $query);

if ($exec) {
    echo json_encode(array('message' => 'Peminjaman baru sukses ditambahkan'));
} else {
    $rollback_query = "UPDATE buku SET jumlah = jumlah + 1 WHERE id = '$buku_id'";
    mysqli_query($conn, $rollback_query);
    echo json_encode(array('message' => 'Peminjaman baru gagal ditambahkan'));
}
?>
