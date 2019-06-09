import os

def build_fm_common():
    ret = os.system("cd ../ && make package PKG=fault/fm-common/")
    return ret

def build_fm_mgr():
    ret = os.system("cd ../ && make package PKG=x.stx-fault/fm-mgr/")
    return ret

def build_fm_api():
    ret = os.system("cd ../ && make package PKG=x.stx-fault/fm-api/")
    return ret

def build_fm_rest_api():
    ret = os.system("cd ../ && make package PKG=x.stx-fault/fm-rest-api/")
    return ret

def build_tsconfig():
    ret = os.system("cd ../ && make package PKG=x.stx-update/tsconfig")
    return ret

def test_fm_common():
    assert build_fm_common() == 0

#def test_fm_mgr():
#    assert build_fm_mgr() == 0

#def test_fm_api():
#    assert build_fm_api() == 0

#def test_fm_rest_api():
#    assert build_fm_rest_api() == 0

#def test_tsconfig():
#    assert build_tsconfig() == 0
