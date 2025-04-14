<?php
include_once 'dbconnect_sakinah.php';

$login = $_POST['login'];
$password = $_POST['password'];

if (!$login || !$password) {
    echo json_encode(array('message' => 'Isi semua kolom'));
} else {
    $query = "SELECT * FROM pengguna WHERE nama = '$login' OR email = '$login'";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $user = mysqli_fetch_assoc($result);

        if ($password == $user['password']) {
            echo json_encode(array(
                'message' => 'Login berhasil',
                'data' => array(
                    'id' => $user['id'],
                    'nama' => $user['nama'],
                    'email' => $user['email']
                )
            ));
        } else {
            echo json_encode(array('message' => 'Password/username salah'));
        }
    } else {
        echo json_encode(array('message' => 'Pengguna tidak ditemukan'));
    }
}
?>
