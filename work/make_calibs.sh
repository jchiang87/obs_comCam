whoami=$(whoami)
repo=/gpfs/slac/lsst/fs1/g/data/dm_data_repos/RTM-005
ts8_data_dir=/gpfs/slac/lsst/fs1/g/data/jobHarness/jh_archive/LCA-11021_RTM/LCA-11021_RTM-005
run_number=6288
num_cores=10

echo "lsst.obs.comCam.ComCamMapper" > $repo/_mapper

ingestImages.py $repo $ts8_data_dir/$run_number/*_acq/v0/*/S*/*.fits

constructBias.py $repo --calib $repo --rerun $whoami/calibs --id imageType='BIAS' run=$run_number --cores $num_cores

ingestCalibs.py $repo --calibType bias $repo/rerun/$whoami/calibs/bias/*/*.fits --validity 9999 --calib $repo --mode=link

constructDark.py $repo --calib $repo --rerun $whoami/calibs --id imageType='DARK' run=$run_number --cores $num_cores

ingestCalibs.py $repo --calibType dark $repo/rerun/$whoami/calibs/dark/*/*.fits --validity 9999 --calib $repo --mode=link

constructFlat.py $repo --calib $repo --rerun $whoami/calibs --id imageType='FLAT' wavelength=500 run=$run_number --cores $num_cores

constructFlat.py $repo --calib $repo --rerun $whoami/calibs --id imageType='FLAT' wavelength=750 run=$run_number --cores $num_cores

constructFlat.py $repo --calib $repo --rerun $whoami/calibs --id imageType='FLAT' wavelength=1000 run=$run_number --cores $num_cores

ingestCalibs.py $repo --calibType flat $repo/rerun/$whoami/calibs/flat/*/*/*.fits --validity 9999 --calib $repo --mode=link
