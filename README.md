# FINPRO PSD PA11
# Data Encryption Standart (DES) Using VHDL

## Anggota
1. Anthonius Henhdy Wirawan (2306161795)
2. Aliya Rizqiningrum Salamun (2306161813)
3. Axel Adrial Paza Kalembang (2306161984)
4. Jeremy Wijanarko Mulyono (2306267132)

# **DATA ENCRYPTION STANDARD**

---

## **1. Background**

Dalam era digital dan teknologi yang berkembang pesat, **keamanan data** menjadi aspek penting untuk melindungi informasi dari ancaman seperti pencurian atau manipulasi.  

**Data Encryption Standard (DES)** adalah algoritma enkripsi simetris klasik yang digunakan untuk mengamankan data dengan menyandikan informasi ke format yang tidak dapat dibaca tanpa kunci dekripsi yang tepat.  

DES bekerja menggunakan kombinasi:  
- **Operasi logika biner**  
- **Permutasi bit**  
- **Rotasi**  

Meskipun DES telah digantikan oleh algoritma modern seperti **AES**, namun DES tetap menjadi **dasar penting** untuk memahami prinsip dasar kriptografi, seperti **permutasi** dan **substitusi** data.  

Penggunaan DES dalam perangkat keras memberikan pemahaman tentang performa dan efisiensi algoritma ini untuk aplikasi praktis seperti sistem penyimpanan dan transfer data.  

---

## **2. How It Works**

Algoritma DES bekerja dalam langkah-langkah berikut:  

1. **Initial Permutation (IP)**  
   - Input data (64-bit) dipermutasikan menggunakan tabel IP standar.

2. **16 Rounds of Feistel Network**  
   - Setiap round terdiri dari:  
     - **Expanding Unit**: Mengubah 32-bit menjadi 48-bit.  
     - **XOR**: Data hasil ekspansi di-XOR dengan sub-kunci (key) yang relevan.  
     - **S-Box**: Substitusi 48-bit input menjadi 32-bit output.  
     - **Permutation**: Distribusi ulang bit menggunakan tabel permutasi.  

3. **Final Permutation (FP)**  
   - Setelah 16 putaran, hasil akhir dipermutasikan kembali menggunakan tabel FP.  

4. **Key Generation**  
   - Kunci 56-bit dipecah menjadi sub-kunci 48-bit untuk setiap putaran.  

---

## **3. How to Use**

### **Proses Enkripsi**
1. **Input Data**: Masukkan file teks berisi data yang akan dienkripsi.  
2. **Pilih Kunci**: Tentukan kunci enkripsi 56-bit yang akan digunakan.  
3. **Jalankan Proses**:  
   - Data diproses melalui **Initial Permutation**.  
   - 16 putaran Feistel Network dilakukan.  
   - Hasilnya diproses melalui **Final Permutation**.  
4. **Output**: Hasil enkripsi disimpan dalam file teks output.  

### **Proses Dekripsi**
1. **Input Enkripsi**: Masukkan file teks berisi data terenkripsi.  
2. **Gunakan Kunci yang Sama**: Dekripsi hanya dapat dilakukan dengan kunci yang sama digunakan saat enkripsi.  
3. **Jalankan Proses Dekripsi**:  
   - Langkah-langkah enkripsi dibalik untuk mengembalikan data ke bentuk asli.  
4. **Output**: Data asli disimpan dalam file teks output.  

---

**Tools yang Digunakan**:  
- **Visual Studio Code**: Coding VHDL  
- **ModelSim**: Simulasi desain  
- **Quartus**: Sintesis perangkat keras  
- **GitHub**: Version control  

---

