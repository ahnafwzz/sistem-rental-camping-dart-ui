# Rental Alat Camping — Flutter Mini App

## Aplikasi

Aplikasi manajemen penyewaan alat camping tiga layar. Pengguna bisa melihat
daftar alat yang tersedia, membuat transaksi sewa lewat form, dan memantau
serta menyelesaikan transaksi aktif dari layar riwayat.

Domain model diambil langsung dari P02 — kelas `Customer`, `Equipment`,
`RentalTransaction`, mixin `Discountable`, dan dua custom exception.

## Bug yang Sempat Membuat Mentok

Setelah form sewa berhasil di-submit dan kembali ke HomeScreen, stok alat
di daftar tidak berubah — padahal di sisi objek `Equipment` stoknya sudah
berkurang.

Saya pertama curiga bug ada di `reduceStock()`, jadi saya tambahkan `print`
di sana untuk memastikan method itu dipanggil. Ternyata method-nya dipanggil
dan nilainya benar. Stok memang berkurang, tapi layar tidak ikut berubah.

Setelah dilihat ulang, masalahnya ada di HomeScreen: `Navigator.push(...)`
dipanggil tanpa `await`, jadi tidak ada yang memberitahu widget untuk rebuild
setelah layar form ditutup. Begitu diubah ke `await Navigator.push(...)` dan
ditambahkan `setState(() {})` sesudahnya, stok langsung terupdate sesuai
kondisi nyata.