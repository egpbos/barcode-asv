import subprocess
import os
import shutil

class RunBarcode:
    working_dir = os.environ['ASV_CONF_DIR']
    timeout = 600  # seconds
    repeat = 10

    def setup(self):
        try:
            os.makedirs(self.working_dir + "/tmp_data")
        except FileExistsError:
            # clean up and retry
            self.teardown()
            os.makedirs(self.working_dir + "/tmp_data")

    def teardown(self):
        shutil.rmtree(self.working_dir + "/tmp_data")
        try:
            os.remove(self.working_dir + "/performance_log.txt")
        except FileNotFoundError:
            pass

    def time_barcode_run(self):
        barcode_exe = os.environ["ASV_ENV_DIR"] + '/bin/barcode'
        subprocess.run([barcode_exe], stdout=subprocess.PIPE, cwd=self.working_dir)
