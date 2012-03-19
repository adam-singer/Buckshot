echo "[buildall.sh] Building all LUCAUI Projects and Demos"

echo
echo
cd debug
./build.sh

echo
echo
cd ../core_tests
./build.sh

echo
echo
cd ../demos/Colors
./build.sh

echo
echo
cd ../ValueConversion
./build.sh

echo
echo
cd ../Life
./build.sh

echo
echo
cd ../tryit
./build.sh

echo
cd ../..

echo "[buildall.sh] Builds Complete"
