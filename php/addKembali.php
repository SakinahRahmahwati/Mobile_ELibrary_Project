<?php
include_once 'dbconnect_sakinah.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $peminjaman_id = $_POST['peminjaman_id'];
    $tanggal_pengembalian = date('Y-m-d');
    $queryBatasPengembalian = "SELECT DATE_ADD(tanggal_peminjaman, INTERVAL 7 DAY) AS batas_pengembalian FROM peminjaman WHERE id = ?";
    $stmtBatasPengembalian = $conn->prepare($queryBatasPengembalian);
    $stmtBatasPengembalian->bind_param("i", $peminjaman_id);
    $stmtBatasPengembalian->execute();
    $result = $stmtBatasPengembalian->get_result()->fetch_assoc();
    $batas_pengembalian = $result['batas_pengembalian'];
    $denda = 0;
    $denda_per_hari = 1000;
    if (strtotime($tanggal_pengembalian) > strtotime($batas_pengembalian)) {
        $selisih_hari = ceil((strtotime($tanggal_pengembalian) - strtotime($batas_pengembalian)) / (60 * 60 * 24));
        $denda = $selisih_hari * $denda_per_hari;
    }
    $queryPengembalian = "INSERT INTO pengembalian (peminjaman_id, tanggal_pengembalian, denda) VALUES (?, ?, ?)";
    $stmtPengembalian = $conn->prepare($queryPengembalian);
    $stmtPengembalian->bind_param("isd", $peminjaman_id, $tanggal_pengembalian, $denda);

    if ($stmtPengembalian->execute()) {
        $queryUpdateStok = "UPDATE buku SET jumlah = jumlah + 1 WHERE id = (SELECT buku_id FROM peminjaman WHERE id = ?)";
        $stmtUpdateStok = $conn->prepare($queryUpdateStok);
        $stmtUpdateStok->bind_param("i", $peminjaman_id);

        if ($stmtUpdateStok->execute()) {
            echo json_encode([
                'Success' => true,
                'Message' => 'Pengembalian berhasil dan stok buku diperbarui!',
                'Denda' => $denda
            ]);
        } else {
            echo json_encode(['Success' => false, 'Message' => 'Gagal memperbarui stok buku.']);
        }
    } else {
        echo json_encode(['Success' => false, 'Message' => 'Gagal menyimpan pengembalian.']);
    }

    $stmtPengembalian->close();
    $stmtUpdateStok->close();
    $stmtBatasPengembalian->close();
    $conn->close();
} else {
    echo json_encode(['Success' => false, 'Message' => 'Metode tidak diizinkan.']);
}
?>
