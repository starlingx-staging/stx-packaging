import os

def build_fm_common():
    ret = os.system("cd ../ && make package")
    return ret
def test_fm_common():
    assert build_fm_common() == 0
