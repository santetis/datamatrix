OBS_PORT=9291
echo "Collecting coverage on port $OBS_PORT..."
#   Start test in one VM
dart --disable-service-auth-codes \
    --enable-vm-service=$OBS_PORT \
    --pause-isolates-on-exit \
    test/coverage.dart &

# Run the coverage collector to generate the JSON coverage report.
collect_coverage \
    --port=$OBS_PORT \
    --out=coverage/coverage.json \
    --wait-paused \
    --resume-isolates

echo "Generating LCOV report..."
format_coverage \
    --lcov \
    --in=coverage/coverage.json \
    --out=coverage/lcov.info \
    --packages=.packages \
    --report-on=lib

exit 0
