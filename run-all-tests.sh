#!/bin/bash

# Daftar skenario VUs yang ingin diuji
# Mulailah dengan angka kecil untuk memastikan semuanya bekerja
SCENARIOS=(10 100 500 1000)

# Durasi tes (pemanasan, penahanan, pendinginan)
RAMP_UP="15s"
DURATION="45s"
RAMP_DOWN="5s"

# Nama file output untuk ringkasan
SUMMARY_FILE="test_summary.txt"

# Hapus file ringkasan lama jika ada
rm -f $SUMMARY_FILE

echo "Memulai Rangkaian Tes Kinerja" | tee -a $SUMMARY_FILE
echo "=================================" | tee -a $SUMMARY_FILE

# Loop melalui setiap skenario
for vus in "${SCENARIOS[@]}"; do
    echo "" | tee -a $SUMMARY_FILE
    echo "--- Menjalankan tes untuk ${vus} VUs ---" | tee -a $SUMMARY_FILE

    # Jalankan k6 dengan override stages dan simpan output ke file
    k6 run \
        --stage ${RAMP_UP}:${vus} \
        --stage ${DURATION}:${vus} \
        --stage ${RAMP_DOWN}:0 \
        --summary-export=$SUMMARY_FILE \
        test-fileserver.js

    echo "--- Tes untuk ${vus} VUs selesai. Beri jeda 10 detik. ---"
    sleep 10
done

echo ""
echo "Semua tes selesai. Hasil tersimpan di ${SUMMARY_FILE}"